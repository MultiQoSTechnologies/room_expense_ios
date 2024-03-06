//
//  UIApplication+Extension.swift
//  DeliveryApp
//
//  Created by MQF-6 on 06/02/24.
//

import UIKit
import NVActivityIndicatorView

let view = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), color: .white)
let uiView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

extension UIApplication {
    func showLoadingIndicator() {
        uiView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.type = .cubeTransition
        view.startAnimating()
        view.center = uiView.center
        uiView.addSubview(view)
        
        UIApplication.shared.topMostVC()?.view.addSubview(uiView)
    }
    
    func hideLoadingIndicator() {
        uiView.removeFromSuperview()
        view.stopAnimating()
    }
}

extension UIApplication {
    
    /// This will return the application AppDelegate instance.
    ///
    ///  This could be nil value also, while using this "appDelegate" please use if let. If you are not using if let and if this returns nil and when you are trying to unwrapped this value then application will crash.
    static var appDelegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }

    /// This will return the AppDelegate UIWindow instance.
    ///
    ///  This could be nil value also, while using this "appDelegateWindow" please use if let. If you are not using if let and if this returns nil and when you are trying to unwrapped this value then application will crash.
    static var window: UIWindow? {
        return UIApplication.sceneDelegate?.window
    }
    
    /// This will return the AppDelegate rootViewController instance.
    ///
    ///  This could be nil value also, while using this "appDelegateWindowRootViewController" please use if let. If you are not using if let and if this returns nil and when you are trying to unwrapped this value then application will crash.
    static var rootViewController: UIViewController? {
        return UIApplication.window?.rootViewController
    }
    
    /// This will return the application SceneDelegate instance.
    ///
    ///  This could be nil value also, while using this "sceneDelegate" please use if let. If you are not using if let and if this returns nil and when you are trying to unwrapped this value then application will crash.
    static var sceneDelegate: SceneDelegate? {
        return UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    }
    
    /// This will return the SceneDelegate UIWindow instance.
    ///
    ///  This could be nil value also, while using this "sceneWindow" please use if let. If you are not using if let and if this returns nil and when you are trying to unwrapped this value then application will crash.
    static var sceneWindow: UIWindow? {
        return UIApplication.sceneDelegate?.window
    }
    
    /// This will return the SceneDelegate  instance.
    ///
    ///  This could be nil value also, while using this "sceneWindowRootViewController" please use if let. If you are not using if let and if this returns nil and when you are trying to unwrapped this value then application will crash.
    static var sceneWindowRootVC: UIViewController? {
        return UIApplication.sceneWindow?.rootViewController
    }
    
    
    func topMostVC(viewController: UIViewController? = UIApplication.sceneWindowRootVC) -> UIViewController? {
        
        if let navigationViewController = viewController as? UINavigationController {
            return UIApplication.shared.topMostVC(viewController: navigationViewController.visibleViewController)
        }
        if let tabBarViewController = viewController as? UITabBarController {
            if let selectedViewController = tabBarViewController.selectedViewController {
                return UIApplication.shared.topMostVC(viewController: selectedViewController)
            }
        }
        if let presentedViewController = viewController?.presentedViewController {
            return UIApplication.shared.topMostVC(viewController: presentedViewController)
        }
        return viewController
    }
    
}
