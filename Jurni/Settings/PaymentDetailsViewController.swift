//
//  PaymentDetailsViewController.swift
//  Jurni
//
//  Created by Devrath Rathee on 08/12/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFunctions

class PaymentDetailsViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,
                                    UITableViewDataSource {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var addUpdateView: UIView!
    @IBOutlet weak var addressLine1: UITextField!
    @IBOutlet weak var addressLine2: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zipPostal: UITextField!
    @IBOutlet weak var creditCardNumber: UITextField!
    @IBOutlet weak var cvc: UITextField!
    @IBOutlet weak var expiryMonth: UITextField!
    @IBOutlet weak var expiryYear: UITextField!
    @IBOutlet weak var addPaymentView: UIView!
    @IBOutlet weak var updatePaymentMethodButton: UIButton!
    @IBOutlet weak var addPaymentMethodButton: UIButton!
    @IBOutlet weak var paymentPlanLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var paymentPlanTableView: UITableView!
    @IBOutlet weak var upcomingPaymentTableView: UITableView!
    @IBOutlet weak var paymentPlanTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var upcomingPaymentTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var totalLabel: UILabel!
    
    var activityView: UIActivityIndicatorView?
    var paymentMethodsArray = [PaymentMethodBean]()
    var paymentPlanArray = [PaymentPlan]()
    var upcomingPaymentArray = [PaymentPlan]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addressLine1.delegate = self
        addressLine2.delegate = self
        city.delegate = self
        state.delegate = self
        zipPostal.delegate = self
        creditCardNumber.delegate = self
        cvc.delegate = self
        expiryMonth.delegate = self
        expiryYear.delegate = self
        
        let paymentPlanNib = UINib(nibName: "PaymentPlanTableViewCell", bundle: nil)
        paymentPlanTableView.register(paymentPlanNib, forCellReuseIdentifier: "PaymentPlanTableViewCell")
        
        
        let upcomingPaymentNib = UINib(nibName: "UpcomingPaymentTableViewCell", bundle: nil)
        upcomingPaymentTableView.register(upcomingPaymentNib, forCellReuseIdentifier: "UpcomingPaymentTableViewCell")
        upcomingPaymentTableView.delegate = self
        upcomingPaymentTableView.dataSource = self
        
        addPaymentView.isHidden = true

        fetchPaymentMethodData()
        fetchStudentBillDetails()
    }

    func fetchPaymentMethodData(){
        let defaultStore: Firestore?
        defaultStore = Firestore.firestore()
        let userId : String = Auth.auth().currentUser!.uid
        print(userId)
        defaultStore?.collection("customerBillingDetails").whereField("uid", isEqualTo: userId)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    self.updatePaymentMethodButton.isHidden = true
                } else {
                    self.paymentMethodsArray.removeAll()
                    var cardsArray = [String]()
                    for document in querySnapshot!.documents {
                       // if(document.get("status") as! String == "ACTIVE")
                       // {
                            // print("\(document.documentID) => \(document.data())")
                            let paymentMethod : [String : Any] = document.data()["meta"] as! [String : Any]
                            
                            let country = paymentMethod["country"] as! String
                            let brand = paymentMethod["brand"] as! String
                            let expMonth = "\(paymentMethod["exp_month"] ?? "")"
                            let expYear = "\(paymentMethod["exp_year"] ?? "")"
                            let lastFour = paymentMethod["last4"] as! String
                           // if(!cardsArray.contains(lastFour)){
                                cardsArray.append(lastFour)
                                self.paymentMethodsArray.append(PaymentMethodBean(cardBrand: brand, expiryMonth: expMonth, expiryYear: expYear, lastFour: lastFour, country: country))
                          //  }
                     //   }
                    }
                    
                    if(self.paymentMethodsArray.isEmpty){
                        self.updatePaymentMethodButton.isHidden = true
                    }
                }
            }
    }
    
    func fetchStudentBillDetails(){
        showActivityIndicator()
        let defaultStore: Firestore?
        defaultStore = Firestore.firestore()
        let userId : String = Auth.auth().currentUser!.uid
        defaultStore?.collection("users").document(userId).collection("communitySettings").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.paymentPlanArray.removeAll()
                var studentIds = [String]()
                for document in querySnapshot!.documents {
                    let documentData : [String : Any] = document.data()
                    if(documentData["studentBillPayment"] != nil){
                        let result: [String:Any] = documentData["studentBillPayment"] as! [String : Any]
                        for(key,value) in result{
                            if(!studentIds.contains(key))
                            {
                                studentIds.append(key)
                                let paymentDetailsArray = value as! NSArray
                                if(paymentDetailsArray.count > 0){
                                    let paymentDetailDict = paymentDetailsArray[0] as! [String : Any]
                                    let cost = paymentDetailDict["cost"] as! NSNumber
                                    let name = paymentDetailDict["name"] as! String
                                    let stamp = (paymentDetailDict["billingDate"] as! Timestamp)
                                    let date = stamp.dateValue().toString(dateFormat: "MMM dd, yyyy")
                                    
                                    let currentDate = Date()
                                    let jurniDate : Date = stamp.dateValue()
                                    var isUpcomingJurni: Bool = false
                                    if jurniDate.compare(currentDate) == .orderedAscending {
                                        isUpcomingJurni = false
                                    }else{
                                        isUpcomingJurni = true
                                    }
                                
                                    self.paymentPlanArray.append(PaymentPlan(billId: key, billingDate: date,
                                                                             cost: "\(cost)", name: name, status: "", isUpcoming: isUpcomingJurni, upcomingDate: jurniDate))
                                }
                            }
                        }
                    }
                }
                if(!self.paymentPlanArray.isEmpty){
                    self.fetchStudentJurnis()
                }else{
                    self.paymentPlanTableView.isHidden = true
                    self.hideActivityIndicator()
                }
            }
        }
    }
    
    
    func fetchStudentJurnis(){
        let defaultStore: Firestore?
        defaultStore = Firestore.firestore()
        defaultStore?.collection("jurnis").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    for(student) in self.paymentPlanArray{
                        if(student.billId == document.documentID){
                           // print("\(document.documentID) ==> \(document.data())")
                            let billingDetails : [String : Any] = document.data()["meta"] as! [String : Any]
                            let billingType = billingDetails["billingType"] as! String
                            if(billingType == "Upfront"){
                                student.status = "One-Time"
                            }else if(billingType == "Recurring"){
                                student.status = "Monlthly Recurring"
                            }else{
                                student.status = "Free"
                            }
                        }
                    }
                }
                let count = self.paymentPlanArray.count
                if(count > 0){
                    self.paymentPlanTableViewHeight.constant = CGFloat(count * 150)
                    self.paymentPlanTableView.reloadData()
                }
                
                var totalPayment: Int = 0
                for(paymentPlan) in self.paymentPlanArray{
                    switch paymentPlan.status{
                    case "One-Time":
                        if(paymentPlan.isUpcoming){
                            self.upcomingPaymentArray.append(paymentPlan)
                            totalPayment += Int(paymentPlan.cost)!
                        }
                    case "Monlthly Recurring":
                        let upcomingPaymentPlan:PaymentPlan = paymentPlan.withPaymentPlan(from: paymentPlan)
                        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: upcomingPaymentPlan.upcomingDate)!
                        let date = nextMonth.toString(dateFormat: "MMMM , yyyy").replacingOccurrences(of: ",", with: "01,")
                        upcomingPaymentPlan.billingDate = date
                        totalPayment += Int(upcomingPaymentPlan.cost)!
                        self.upcomingPaymentArray.append(upcomingPaymentPlan)
                    default:
                        print("Default case")
                    }
                }
                
                self.totalLabel.text = "TOTAL - $\(totalPayment)"
                
                let upcomingCount = self.upcomingPaymentArray.count
                if(upcomingCount > 0){
                    self.upcomingPaymentTableViewHeight.constant = CGFloat(upcomingCount * 140)
                    self.upcomingPaymentTableView.reloadData()
                }
                
                self.hideActivityIndicator()
            }
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        addPaymentMethodButton.isHidden = false
        updatePaymentMethodButton.isHidden = false
        addUpdateView.isHidden = false
        addPaymentView.isHidden = true
    }
    
    @IBAction func saveAction(_ sender: Any) {
        //https://us-central1-jurni-dev.cloudfunctions.net/registerCustomer
        
        let userDocumentId : String = Auth.auth().currentUser!.uid
        let communityId: String = UserDefaults.standard.string(forKey: Constants.COMMUNITY_ID) ?? ""
        let customerArray : [String: Any] = [
            "uid": userDocumentId,
            "communityId": communityId,
            "address_line_one":"pune",
            "address_line_two":"pune",
            "city":"pune",
            "stateCode":"CO",
            "zip_code":"423323",
            "card_no":"1232123234322233",
            "exp_month":"03",
            "exp_year":"2027",
            "cvc":"000"
        ]
        lazy var functions = Functions.functions()
        functions.httpsCallable("https://us-central1-jurni-dev.cloudfunctions.net/registerCustomer/registerBilling").call(customerArray){result, error in
            print(result)
            print(error)
            
        }
    }
    
    @IBAction func updatePaymentAction(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! UpdatePaymentPopUpViewController
            destinationVC.updatePaymentArray = paymentMethodsArray
    }
    
    @IBAction func addPaymentAction(_ sender: Any) {
        addPaymentMethodButton.isHidden = true
        updatePaymentMethodButton.isHidden = true
        addUpdateView.isHidden = true
        addPaymentView.isHidden = false
        
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func showActivityIndicator() {
        activityView = UIActivityIndicatorView(style: .large)
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }
    
    func hideActivityIndicator(){
        if (activityView != nil){
            activityView?.stopAnimating()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == paymentPlanTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentPlanTableViewCell", for: indexPath)
            as! PaymentPlanTableViewCell
          
            cell.transactionName.text = paymentPlanArray[indexPath.row].name
            cell.status.text = paymentPlanArray[indexPath.row].status
            cell.cost.text = "$\(paymentPlanArray[indexPath.row].cost)"
        
            if(paymentPlanArray[indexPath.row].status == "Monlthly Recurring"){
                cell.billingDate.text = "Subscribed \(paymentPlanArray[indexPath.row].billingDate)"
                cell.action.text = "Cancel jurni"
            }else{
                cell.billingDate.text = "Paid \(paymentPlanArray[indexPath.row].billingDate)"
                cell.action.text = "N/A"
            }
            
            let cellNameTapped = UITapGestureRecognizer(target: self, action: #selector(nameTapped))
            cell.action.isUserInteractionEnabled = true
            cell.action.addGestureRecognizer(cellNameTapped)

            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingPaymentTableViewCell", for: indexPath)
            as! UpcomingPaymentTableViewCell
            
            cell.tansactionName.text = upcomingPaymentArray[indexPath.row].name
            cell.cost.text = "$\(upcomingPaymentArray[indexPath.row].cost)"
            cell.upcomingBillingDate.text = upcomingPaymentArray[indexPath.row].billingDate
            return cell
        }
    }
    
    @objc func nameTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let lableView = tapGestureRecognizer.view as! UILabel
        if(lableView.text == "Cancel jurni"){
            let view = tapGestureRecognizer.view
            let indexPath = paymentPlanTableView.indexPathForView(view!)
            let paymentPlan = paymentPlanArray[indexPath!.row]
            cancelJurni(jurniId: paymentPlan.billId)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == paymentPlanTableView{
            return paymentPlanArray.count
        }else {
            return upcomingPaymentArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}

    func cancelJurni(jurniId:String){
        let defaultStore: Firestore?
        defaultStore = Firestore.firestore()
        let documentRef = defaultStore?.collection("jurnis").document(jurniId)
        documentRef!.getDocument { (document, error) in
            let members : [Any] = document?.data()!["members"] as! [Any]
            let userId : String = Auth.auth().currentUser!.uid
            let userToDelete = "users/\(userId)"
            
            if let toDelete = members.first(where: { (member) -> Bool in
                        if let object = member as? DocumentReference,
                           object.path == userToDelete {
                            return true
                        } else {
                            return false
                        }
                    }) {
                
                documentRef?.updateData([
                    "members": FieldValue.arrayRemove([toDelete])
                        ]){ error in
                            if let error = error {
                                print("error: \(error)")
                            } else {
                                print("successfully deleted")
                                self.viewDidLoad()
                            }
                        }
                    }
        }
    }
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

public extension UITableView {

  func indexPathForView(_ view: UIView) -> IndexPath? {
    let origin = view.bounds.origin
    let viewOrigin = self.convert(origin, from: view)
    let indexPath = self.indexPathForRow(at: viewOrigin)
    return indexPath
  }
}
