//
//  StudentBillPayment.swift
//  Jurni
//
//  Created by Devrath Rathee on 20/12/22.
//

import UIKit

class StudentBillPayment: NSObject {
    var billingDate: String
    var cost: String
    var name: String
    
    init(billingDate: String, cost: String, name: String) {
        self.billingDate = billingDate
        self.cost = cost
        self.name = name
        
        super.init()
    }
}
