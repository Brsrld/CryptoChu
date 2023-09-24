//
//  UIViewController+Extension.swift
//  PetStore
//
//  Created by Brsrld on 21.08.2023.
//

import Foundation
import UIKit

// MARK: - UIViewController Extension
extension UIViewController {
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
