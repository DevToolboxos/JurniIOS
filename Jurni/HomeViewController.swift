//
//  SlideMenuViewController.swift
//  Jurni
//
//  Created by Devrath Rathee on 29/11/22.
//

import Foundation
import UIKit

class HomeViewController : UIViewController{
    
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuBtn.target = revealViewController()
                sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
    }
    
    
}
