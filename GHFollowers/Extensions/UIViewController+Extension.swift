//
//  UIViewController+Extension.swift
//  GHFollowers
//
//  Created by Він on 30.05.2024.
//

import UIKit

extension UIViewController {
    func presentGFAlert(title: String, message: String, buttonTitle: String) {
        let alertVC = GFAlertViewController(alertTitle: title, message: message, buttonTitle: buttonTitle)
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        self.present(alertVC, animated: true)
    }
    
    func presentDefaultAlert() {
        let alertVC = GFAlertViewController(
            alertTitle: "We have a problem",
            message: "We can't do your task now. Try again later",
            buttonTitle: "OK")
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        self.present(alertVC, animated: true)
    }
}
