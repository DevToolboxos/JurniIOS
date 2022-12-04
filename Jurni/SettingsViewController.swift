//
//  SettingsViewController.swift
//  Jurni
//
//  Created by Devrath Rathee on 29/11/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore

class SettingsViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var accountBtn: UIButton!
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var accountLabel: UILabel!
    
    @IBOutlet weak var paymentBtn: UIButton!
    @IBOutlet weak var paymentImageView: UIImageView!
    @IBOutlet weak var paymentLabel: UILabel!
    
    @IBOutlet weak var onboardingBtn: UIButton!
    @IBOutlet weak var onboardingImageView: UIImageView!
    @IBOutlet weak var onboardingLabel: UILabel!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var hobbiesTextField: UITextField!
    @IBOutlet weak var currentPwdTextField: UITextField!
    @IBOutlet weak var newPwdTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        jobTitleTextField.delegate = self
        hobbiesTextField.delegate = self
        currentPwdTextField.delegate = self
        newPwdTextField.delegate = self
        
        
        self.firstNameTextField.text = UserDefaults.standard.string(forKey: Constants.FIRST_NAME)
        self.lastNameTextField.text = UserDefaults.standard.string(forKey: Constants.LAST_NAME)
        self.emailTextField.text = UserDefaults.standard.string(forKey: Constants.EMAIL)
        self.phoneTextField.text = UserDefaults.standard.string(forKey: Constants.PHONE_NUMBER)
        self.jobTitleTextField.text = UserDefaults.standard.string(forKey: Constants.JOB_TITLE)
        self.hobbiesTextField.text = UserDefaults.standard.string(forKey: Constants.HOBBIES)

    }
    
    @IBAction func backArrowAction(_ sender: Any) {
        print("back button")
        self.dismiss(animated: true, completion: nil)
       // self.navigationController?.popViewController(animated: false)
        
    }
    
    @IBAction func accountAction(_ sender: Any) {
      //  self.accountBtn.backgroundColor = UIColor(patternImage: UIImage(named: "settingwhitebg.png")!)
      //  self.paymentBtn.backgroundColor = UIColor(patternImage: UIImage(named: "settingwhiteborder.png")!)
      //  self.onboardingBtn.backgroundColor = UIColor(patternImage: UIImage(named: "settingwhiteborder.png")!)
        
        
    }
    
    @IBAction func paymentAction(_ sender: Any) {
    
        
    }
    
    @IBAction func onboardingAction(_ sender: Any) {
        
    }
    
    @IBAction func saveAction(_ sender: Any) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
