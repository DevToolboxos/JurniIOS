//
//  StudentBillPayment.swift
//  Jurni
//
//  Created by Devrath Rathee on 20/12/22.
//

import UIKit

class PaymentPlan: NSObject {
    var billId: String
    var billingDate: String
    var cost: String
    var name: String
    var status: String
    
    init(billId: String, billingDate: String, cost: String, name: String, status: String) {
        self.billId = billId
        self.billingDate = billingDate
        self.cost = cost
        self.name = name
        self.status = status
        
        super.init()
    }
}
