//
//  ViewController.swift
//  Jurni
//
//  Created by Devrath Rathee on 16/11/22.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginAction(_ sender: Any) {
        let email : String = emailTextField.text ?? ""
        let password : String = passwordTextField.text ?? ""
        if(!email.isEmpty && !password.isEmpty){
            login(email: email, password: password)
        }else{
            self.performSegue(withIdentifier: "dashboardSegue", sender: nil)
         //  showAlert(message: "Enter both Email and Password")
        }
    }
    
    func login(email: String, password:String){
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if(authResult == nil){
                self!.showAlert(message: "Enter valid Email and Password")
            }else{
                self!.performSegue(withIdentifier: "dashboardSegue", sender: nil)
            }
        }
    }

    func showAlert(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

