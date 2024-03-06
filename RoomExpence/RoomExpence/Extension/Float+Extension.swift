//
//  Float_Extension.swift
//  RoomExpence
//
//  Created by MQF-6 on 28/02/24.
//

import UIKit

extension Float {
    
    var toInt:Int? {
        return Int(self)
    }
    
    var toDouble:Double? {
        return Double(self)
    }
    
    var toString:String {
        return "\(self)"
    }
    
    var toCGFloat:CGFloat {
        return CGFloat(self)
    }
    
    var aspectRatio: CGFloat {
        return UIDevice.screenWidth * (self.toCGFloat / UIDevice.width)
    }
}
