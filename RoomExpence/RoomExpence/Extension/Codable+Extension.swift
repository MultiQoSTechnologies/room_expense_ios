//
//  Codable+Extension.swift
//  DeliveryApp
//
//  Created by MQF-6 on 06/02/24.
//

import Foundation

extension Encodable {
    func dictionary() -> [String:Any] {
        var dict = [String:Any]()
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            guard let key = child.label else { continue }
            let childMirror = Mirror(reflecting: child.value)
            
            switch childMirror.displayStyle {
            case .struct, .class:
                let childDict = (child.value as! Encodable).dictionary()
                dict[key] = childDict
            case .collection:
                let childArray = (child.value as! [Encodable]).map({ $0.dictionary() })
                dict[key] = childArray
            case .set:
                let childArray = (child.value as! Set<AnyHashable>).map({ ($0 as! Encodable).dictionary() })
                dict[key] = childArray
            default:
                dict[key] = child.value
            }
        }
        
        return dict
    }
}

extension Dictionary {
    func castToObject<T: Decodable>() -> T? {
        let json = try? JSONSerialization.data(withJSONObject: self)
        return json == nil ? nil : try? JSONDecoder().decode(T.self, from: json!)
    }
}
