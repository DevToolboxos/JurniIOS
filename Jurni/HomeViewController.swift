//
//  SlideMenuViewController.swift
//  Jurni
//
//  Created by Devrath Rathee on 29/11/22.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore

class HomeViewController : UIViewController{
    
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuBtn.target = revealViewController()
                sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
        fetchUserData()
    }
    
    func fetchUserData(){
        let defaultStore: Firestore?
        defaultStore = Firestore.firestore()
        let userId : String = Auth.auth().currentUser!.uid
        let docRef = defaultStore?.collection("users").document(userId)
        docRef!.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                
                let firstName = document.get("firstName") as? String
                if(firstName != nil){
                    UserDefaults.standard.set(firstName, forKey: Constants.FIRST_NAME)
                }
                
                let lastName = document.get("lastName") as? String
                if(lastName != nil){
                    UserDefaults.standard.set(lastName, forKey: Constants.LAST_NAME)
                }
                
                let email = document.get("email") as? String
                if(email != nil){
                    UserDefaults.standard.set(email, forKey: Constants.EMAIL)
                }
                
                let phone = document.get("phone") as? String
                if(phone != nil){
                    UserDefaults.standard.set(phone, forKey: Constants.PHONE_NUMBER)
                }
                
                let jobTitle = document.get("jobTitle") as? String
                if(jobTitle != nil){
                    UserDefaults.standard.set(jobTitle, forKey: Constants.JOB_TITLE)
                }
                
                let avatar = document.get("avatar") as? String
                if(avatar != nil){
                    UserDefaults.standard.set(avatar, forKey: Constants.PROFILE_PIC)
                }
                
                let hobbies = document.get("hobbies") as? String
                if(hobbies != nil){
                    UserDefaults.standard.set(hobbies, forKey: Constants.HOBBIES)
                }
                
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
}
