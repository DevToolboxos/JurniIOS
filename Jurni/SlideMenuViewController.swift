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
    var sideMenuDelegate: SideMenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pictureTap = UITapGestureRecognizer(target: self, action: #selector(SlideMenuViewController.imageTapped))
        settingsImageView.addGestureRecognizer(pictureTap)
        settingsImageView.isUserInteractionEnabled = true
        
        
    }
    
    @objc func imageTapped() {
        self.sideMenuDelegate?.selectedCell(4)
    }
}
