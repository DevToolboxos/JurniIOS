//
//  SlideMenuViewController.swift
//  Jurni
//
//  Created by Devrath Rathee on 29/11/22.
//

import Foundation
import UIKit

protocol SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int)
}

class SlideMenuViewController : UIViewController{
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var settingsImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var communityImageView: UIImageView!
    @IBOutlet weak var communityNameLabel: UILabel!
    @IBOutlet weak var communityDescriptionLabel: UILabel!
    
    
    var sideMenuDelegate: SideMenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pictureTap = UITapGestureRecognizer(target: self, action: #selector(SlideMenuViewController.imageTapped))
        settingsImageView.addGestureRecognizer(pictureTap)
        settingsImageView.isUserInteractionEnabled = true
        
        self.userNameLabel.text = UserDefaults.standard.string(forKey: Constants.FIRST_NAME)
        self.communityNameLabel.text = UserDefaults.standard.string(forKey: Constants.COMMUNITY_NAME)
        self.communityDescriptionLabel.text = UserDefaults.standard.string(forKey: Constants.COMMUNITY_DESCRIPTION)
        
        let communityLogo = UserDefaults.standard.string(forKey: Constants.COMMUNITY_LOGO)
        if(communityLogo != nil){
            let communityLogoUrl = URL(string:  communityLogo ?? "")
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: communityLogoUrl!)
                DispatchQueue.main.async {
                    self.communityImageView.image = UIImage(data: data!)
                }
            }
        }
        
        let profilePic = UserDefaults.standard.string(forKey: Constants.PROFILE_PIC)
        if(profilePic != nil){
            let profilePicUrl = URL(string:  profilePic!)
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: profilePicUrl!)
                DispatchQueue.main.async {
                    self.userImageView.image = UIImage(data: data!)
                }
            }
        }
       
    }
    
    @objc func imageTapped() {
        self.sideMenuDelegate?.selectedCell(4)
    }
}
