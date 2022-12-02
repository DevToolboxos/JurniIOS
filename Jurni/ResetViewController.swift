//
//  ResetViewController.swift
//  Jurni
//
//  Created by Devrath Rathee on 19/11/22.
//

import Foundation
import UIKit
import FirebaseAuth

class ResetViewController : UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
    }
    
    @IBAction func resetPasswordAction(_ sender: Any) {
        let email : String = emailTextField.text ?? ""
        
        if(!email.isEmpty){
            sendResetPasswordLink(email: email)
        }else{
           showAlert(message: "Enter Email")
        }
    }
    
    func sendResetPasswordLink(email: String){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if(error == nil){
                self.showPasswordResetLinkAlert(message: "Password reset link sent to your email")
            }else{
                self.showAlert(message: "Enter valid email")
            }
        }
    }

    func showAlert(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showPasswordResetLinkAlert(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
    
    func handler(alert: UIAlertAction!){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
