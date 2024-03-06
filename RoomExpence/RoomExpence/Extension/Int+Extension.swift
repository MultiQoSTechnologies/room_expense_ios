//
//  Int+Extension.swift
//  RoomExpence
//
//  Created by MQF-6 on 04/03/24.
//

import UIKit

// MARK: - Extension of Int For Converting it TO String.
extension Int {
    
    /// A Computed Property (only getter) of String For getting the String value from Int.
    var toString:String {
        return "\(self)"
    }
    
    var toDouble:Double {
        return Double(self)
    }
    
    var toFloat:Float {
        return Float(self)
    }
    
    var toCGFloat:CGFloat {
        return CGFloat(self)
    }
    
    var aspectRatio: CGFloat {
        return UIDevice.screenWidth * (self.toCGFloat / UIDevice.width)
    }
    
}
