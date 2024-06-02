//
//  UIViewController+Extension.swift
//  GHFollowers
//
//  Created by Він on 30.05.2024.
//

import UIKit
import SafariServices

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
    
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.8
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingView() {
        containerView.removeFromSuperview()
        containerView = nil
    }
    
    func showEmptyStateView(message: String, view: UIView) {
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    
    func presentSafariViewController(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
}

fileprivate var containerView: UIView!
