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
import FirebaseCoreExtension
import FirebaseMessagingInterop

class PaymentDetailsViewController: UIViewController,UITextFieldDelegate {

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
    
    @IBOutlet weak var uiview: UIView!
    
    @IBOutlet weak var addPaymentView: UIView!
    
    @IBOutlet weak var updatePaymentMethodButton: UIButton!
    @IBOutlet weak var addPaymentMethodButton: UIButton!
    @IBOutlet weak var paymentPlanLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var paymentMethodsArray = [PaymentMethodBean]()
    
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
        
        addPaymentView.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)

        fetchPaymentMethodData()
        fetchStudentBillDetails()
    }
    

    func fetchPaymentMethodData(){
       // showActivityIndicator()
        let defaultStore: Firestore?
        defaultStore = Firestore.firestore()
        let userId : String = Auth.auth().currentUser!.uid
       
        defaultStore?.collection("customerBillingDetails").whereField("uid", isEqualTo: userId)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    self.updatePaymentMethodButton.isHidden = true
                } else {
                    print(querySnapshot!.documents.count)
                    self.paymentMethodsArray.removeAll()
                    var cardsArray = [String]()
                    for document in querySnapshot!.documents {
                        if(document.get("status") as! String == "ACTIVE"){
                            // print("\(document.documentID) => \(document.data())")
                            let paymentMethod : [String : Any] = document.data()["meta"] as! [String : Any]
                            
                            let country = paymentMethod["country"] as! String
                            let brand = paymentMethod["brand"] as! String
                            let expMonth = "\(paymentMethod["exp_month"] ?? "")"
                            let expYear = "\(paymentMethod["exp_year"] ?? "")"
                            let lastFour = paymentMethod["last4"] as! String
                            if(!cardsArray.contains(lastFour)){
                                cardsArray.append(lastFour)
                                self.paymentMethodsArray.append(PaymentMethodBean(cardBrand: brand, expiryMonth: expMonth, expiryYear: expYear, lastFour: lastFour, country: country))
                            }
                        }
                    }
                    
                    if(self.paymentMethodsArray.isEmpty){
                        self.updatePaymentMethodButton.isHidden = true
                    }
                }
            }
        
    }
    
    func fetchStudentBillDetails(){
        let defaultStore: Firestore?
        defaultStore = Firestore.firestore()
        let userId : String = Auth.auth().currentUser!.uid
        defaultStore?.collection("users").document(userId).collection("communitySettings").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var studentBillsIds = [String]()
                var studentBillPayments = [StudentBillPayment]()
                for document in querySnapshot!.documents {
                    let documentData : [String : Any] = document.data()
                    if(documentData["studentBillPayment"] != nil){
                        print("Student billing =>")
                        print("\(document.documentID) => \(document.data())")
                        let result: [String:Any] = documentData["studentBillPayment"] as! [String : Any]
                        for(key,value) in result{
                            print("key: " + key)
                            if(!studentBillsIds.contains(key)){
                                studentBillsIds.append(key)
                                print("value \(value as! NSArray)")
                              //  let billDate = NSDate(timeIntervalSince1970: 23423253) as! String
                               // studentBillPayments.append(StudentBillPayment(billingDate: "", cost: "5.0", name: ""))
                            }
                        }
                    }
                }
                if(!studentBillsIds.isEmpty){
                    self.fetchStudentJurnis(studentIds: studentBillsIds)
                }
            }
        }
        
       
    }
    
    func fetchStudentJurnis(studentIds: [String]){
        let defaultStore: Firestore?
        defaultStore = Firestore.firestore()
        let userId : String = Auth.auth().currentUser!.uid
        defaultStore?.collection("jurnis").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("Jurnis :")
                for document in querySnapshot!.documents {
                    for(student) in studentIds{
                        if(student == document.documentID){
                            print("\(document.documentID) => \(document.data())")
                            
                        }
                    }
                }
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
    
    
}


