//
//  SettingsViewController.swift
//  Jurni
//
//  Created by Devrath Rathee on 29/11/22.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var accountBtn: UIButton!
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var accountLabel: UILabel!
    
    @IBOutlet weak var paymentBtn: UIButton!
    @IBOutlet weak var paymentImageView: UIImageView!
    @IBOutlet weak var paymentLabel: UILabel!
    
    @IBOutlet weak var onboardingBtn: UIButton!
    @IBOutlet weak var onboardingImageView: UIImageView!
    @IBOutlet weak var onboardingLabel: UILabel!
    

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        addContactDetailsViewController()
    }
    
    @IBAction func backArrowAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func accountAction(_ sender: Any) {
        self.accountBtn.setImage(UIImage(named: "settingwhitebg.png"), for: .normal)
        self.paymentBtn.setImage(UIImage(named: "settingwhiteborder.png"), for: .normal)
        self.onboardingBtn.setImage(UIImage(named: "settingwhiteborder.png"), for: .normal)

        self.accountImageView.image = UIImage(named: "account.png")
        self.paymentImageView.image = UIImage(named: "paymentswhite.png")
        self.onboardingImageView.image = UIImage(named: "onboardwhite.png")
        
        self.accountLabel.textColor = UIColor(red: 0.061, green: 0.088, blue: 0.107, alpha: 1.0)
        self.paymentLabel.textColor = UIColor.white
        self.onboardingLabel.textColor = UIColor.white
        
        titleLabel.text = "Contact Details"
        
        removePaymentDetailsViewController()
        addContactDetailsViewController()
            
    }
    
    @IBAction func paymentAction(_ sender: Any) {
        self.accountBtn.setImage(UIImage(named: "settingwhiteborder.png"), for: .normal)
        self.paymentBtn.setImage(UIImage(named: "settingwhitebg.png"), for: .normal)
        self.onboardingBtn.setImage(UIImage(named: "settingwhiteborder.png"), for: .normal)

        self.accountImageView.image = UIImage(named: "accountswhite.png")
        self.paymentImageView.image = UIImage(named: "payments.png")
        self.onboardingImageView.image = UIImage(named: "onboardwhite.png")
        
        self.accountLabel.textColor = UIColor.white
        self.paymentLabel.textColor = UIColor(red: 0.061, green: 0.088, blue: 0.107, alpha: 1.0)
        self.onboardingLabel.textColor = UIColor.white
                
        titleLabel.text = "Billing Information"
        
        removeContactDetailsViewController()
        addPaymentDetailsViewController()
    }
    
    @IBAction func onboardingAction(_ sender: Any) {
        self.accountBtn.setImage(UIImage(named: "settingwhiteborder.png"), for: .normal)
        self.paymentBtn.setImage(UIImage(named: "settingwhiteborder.png"), for: .normal)
        self.onboardingBtn.setImage(UIImage(named: "settingwhitebg.png"), for: .normal)
   
        self.accountImageView.image = UIImage(named: "accountswhite.png")
        self.paymentImageView.image = UIImage(named: "paymentswhite.png")
        self.onboardingImageView.image = UIImage(named: "onboard.png")
        
        self.accountLabel.textColor = UIColor.white
        self.paymentLabel.textColor = UIColor.white
        self.onboardingLabel.textColor = UIColor(red: 0.061, green: 0.088, blue: 0.107, alpha: 1.0)
        
        titleLabel.text = ""
    }
    
  
    @IBAction func logoutAction(_ sender: Any) {        
        let defaults = UserDefaults.standard
            let dictionary = defaults.dictionaryRepresentation()
            dictionary.keys.forEach { key in
                defaults.removeObject(forKey: key)
            }
        
        self.performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    

    
    func addContactDetailsViewController(){
        if let contactDetailsViewController = self.storyboard?.instantiateViewController(identifier: "contactDetailsID") as? ContactDetailsViewController {
            
            addChild(contactDetailsViewController)
            containerView.addSubview(contactDetailsViewController.view)
        
        }
    }
    
    func addPaymentDetailsViewController(){
        if let paymentDetailsViewController = self.storyboard?.instantiateViewController(identifier: "paymentDetailsID") as? PaymentDetailsViewController {
            
            addChild(paymentDetailsViewController)
            containerView.addSubview(paymentDetailsViewController.view)
        
        }
    }
    
    func removeContactDetailsViewController(){
        if let contactDetailsViewController = self.storyboard?.instantiateViewController(identifier: "contactDetailsID") as? ContactDetailsViewController {
            contactDetailsViewController.view.removeFromSuperview()
            contactDetailsViewController.removeFromParent()
        }
    }
    
    func removePaymentDetailsViewController(){
        if let paymentDetailsViewController = self.storyboard?.instantiateViewController(identifier: "paymentDetailsID") as? PaymentDetailsViewController {
            paymentDetailsViewController.view.removeFromSuperview()
            paymentDetailsViewController.removeFromParent()
        }
    }
}
