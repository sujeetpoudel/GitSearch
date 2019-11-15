//
//  CommonExtensions.swift
//
//  Created by Chanappa on 23/08/19.
//

import Foundation
import UIKit

extension Bundle {
    static func appName() -> String {
        guard
            let dictionary = Bundle.main.infoDictionary,
            let version : String = dictionary["CFBundleName"] as? String
        else {
            return ""
        }
        return version
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UIView {
    
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 5
        clipsToBounds = false
    }
}
