//
//  String+Extension.swift
//  DeliveryApp
//
//  Created by MQF-6 on 06/02/24.
//

import UIKit

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}

extension String {
    func getWidth(font: UIFont) -> CGFloat {
        let bounds = (self as NSString).size(withAttributes: [.font:font])
        return bounds.width
    }
    
    func getHeight(font: UIFont) -> CGFloat {
        let bounds = (self as NSString).size(withAttributes: [.font:font])
        return bounds.height
    }
}

extension String {
    var jsonToDictionary: [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                AppPrint.print(error.localizedDescription)
            }
        }
        return nil
    }
}

extension String {
    var toInt: Int {
        return Int(self) ?? 0
    }
    var toDouble: Double? {
        return Double(self)
    }
    var toFloat: Float? {
        return Float(self)
    }
    var toURL: URL? {
        return URL(string: self)
    }
}
