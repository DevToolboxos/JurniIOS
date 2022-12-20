//
//  PaymentMethodBean.swift
//  Jurni
//
//  Created by Devrath Rathee on 16/12/22.
//

import Foundation

class PaymentMethodBean: NSObject {

    var brand : String
    var expMonth : String
    var expYear : String
    var last4 : String
    var country : String
    
    init(cardBrand : String, expiryMonth : String,
         expiryYear : String, lastFour : String,
         country : String) {
        self.brand = cardBrand
        self.expMonth = expiryMonth
        self.expYear = expiryYear
        self.last4 = lastFour
        self.country = country
        
        super.init()
    }
}
