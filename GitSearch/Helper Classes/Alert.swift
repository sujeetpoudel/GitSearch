//
//  Alert.swift
//
//  Created by Chanappa on 23/08/19.
//

import Foundation
import UIKit

let appTitle = Bundle.appName()

class Alert {
    
    class func showNormalAlertWith( title: String = appTitle, message: String){
        let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertcontroller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            guard let topController = UIApplication.topViewController() else { return }
            topController.present(alertcontroller, animated: true, completion: nil)
        }
    }
    
}
