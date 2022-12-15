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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addressLine1.delegate = self
        
        addPaymentView.isHidden = true
        
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)

        fetchUserData()
    }
    

    func fetchUserData(){
       // showActivityIndicator()
        let defaultStore: Firestore?
        defaultStore = Firestore.firestore()
        let userId : String = Auth.auth().currentUser!.uid
        print(userId)
        let docRef = defaultStore?.collection("customerBillingDetails").document(userId)
        
        print("Getting documents:")
        defaultStore?.collection("customerBillingDetails").whereField("uid", isEqualTo: userId)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        
                    }
                }
        }
        
        
        docRef!.getDocument { (document, error) in
          //  self.hideActivityIndicator()
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                print("Desc : " + dataDescription)
//                let firstName = document.get("firstName") as? String
//                if(firstName != nil){
//                    UserDefaults.standard.set(firstName, forKey: Constants.FIRST_NAME)
//                }
//
//                let lastName = document.get("lastName") as? String
//                if(lastName != nil){
//                    UserDefaults.standard.set(lastName, forKey: Constants.LAST_NAME)
//                }
//
//                let email = document.get("email") as? String
//                if(email != nil){
//                    UserDefaults.standard.set(email, forKey: Constants.EMAIL)
//                }
//
//                let phone = document.get("phone") as? String
//                if(phone != nil){
//                    UserDefaults.standard.set(phone, forKey: Constants.PHONE_NUMBER)
//                }
//
//                let jobTitle = document.get("jobTitle") as? String
//                if(jobTitle != nil){
//                    UserDefaults.standard.set(jobTitle, forKey: Constants.JOB_TITLE)
//                }
//
//                let avatar = document.get("avatar") as? String
//                if(avatar != nil){
//                    UserDefaults.standard.set(avatar, forKey: Constants.PROFILE_PIC)
//                }
//
//                let hobbies = document.get("hobbies") as? String
//                if(hobbies != nil){
//                    UserDefaults.standard.set(hobbies, forKey: Constants.HOBBIES)
//                }
                
              //  self.setUserData()
                
            } else {
                print("Document does not exist")
            }
        }
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        addPaymentMethodButton.isHidden = false
        updatePaymentMethodButton.isHidden = false
        addPaymentView.isHidden = true
    }
    @IBAction func saveAction(_ sender: Any) {
        //https://us-central1-jurni-dev.cloudfunctions.net/registerCustomer
        lazy var functions = Functions.functions()
      //  functions.httpsCallable(<#T##URL#>, requestAs: <#T##Request#>, responseAs: <#T##Response#>, encoder: <#T##FirebaseDataEncoder#>, decoder: <#T##FirebaseDataDecoder#>)
    }
    
    @IBAction func updatePaymentAction(_ sender: Any) {
            
    }
    
    @IBAction func addPaymentAction(_ sender: Any) {
        addPaymentMethodButton.isHidden = true
        updatePaymentMethodButton.isHidden = true
        addPaymentView.isHidden = false
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
