//
//  UIViewController+Extension.swift
//  DeliveryApp
//
//  Created by MQF-6 on 06/02/24.
//

import UIKit
import NVActivityIndicatorView
import SnackBar

extension UIViewController {
    func showToast(message: String) { 
        AppSnackBar.make(in: self.view, message: message, duration: .lengthLong).show()
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Extension of UIViewController For AlertView with Different Numbers of Buttons -
extension UIViewController {
    
    func showAlert(title: String? = nil, message: String? = nil, style: UIAlertController.Style = .alert, actions: [String] = [],  handler: ((String) -> Void)? = nil) {
        
        var _actions = actions
        if actions.isEmpty {
            _actions.append("Okay")
        }
        var arrAction : [UIAlertAction] = []
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let onSelect : ((UIAlertAction) -> Void)? = { (alert) in
            guard let index = arrAction.index(of: alert) else {
                return
            }
            handler?(_actions[index])
        }
        for action in _actions {
            arrAction.append(UIAlertAction(title: action, style: .default, handler: onSelect))
        }
        let _ = arrAction.map({alertController.addAction($0)})
        self.present(alertController, animated: true, completion: nil)
    }
}
 

class AppSnackBar: SnackBar {
    
    override var style: SnackBarStyle {
        var style = SnackBarStyle()
        style.background = .appBlack
        style.textColor = .appWhite
        self.layer.cornerRadius = 15
        style.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return style
    }
}
