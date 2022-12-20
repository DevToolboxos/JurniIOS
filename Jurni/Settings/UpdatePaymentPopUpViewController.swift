//
//  UpdatePaymentPopUpViewController.swift
//  Jurni
//
//  Created by Devrath Rathee on 18/12/22.
//

import UIKit

class UpdatePaymentPopUpViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var updatePaymentArray = [PaymentMethodBean]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "UpdatePaymentTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "UpdatePaymentTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("clicked ")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updatePaymentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpdatePaymentTableViewCell", for: indexPath) as! UpdatePaymentTableViewCell
        let paymentMethod = updatePaymentArray[indexPath.row]
        
        cell.cardType.text = paymentMethod.brand
        cell.lastFour.text = paymentMethod.last4
        cell.action.text = "Active"
        
        return cell
    }

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
