//
//  Double+Extension.swift
//  DeliveryApp
//
//  Created by MQF-6 on 07/02/24.
//

import UIKit

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    var toInt:Int? {
        return Int(self)
    }
    
    var toDouble:Double? {
        return Double(self)
    }
    
    var toString:String {
        return "\(self)"
    } 
}
