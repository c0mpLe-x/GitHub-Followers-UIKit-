//
//  SearchViewController.swift
//  GHFollowers
//
//  Created by Він on 30.05.2024.
//

import UIKit

class SearchViewController: UIViewController {
    let logoImageView = UIImageView()
    let usernameTextField = GitFollowersTextField()
    let getFollowersButton = GitFollowersButton(backgroundColor: .systemGreen, title: "Get Followers")
    
    var isUserNameEntered: Bool {
        !usernameTextField.text!.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureImageLogoView()
        configureTextField()
        configureGetFollowersButton()
        createDidmissKeyboardTapGesture()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func configureImageLogoView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(resource: .ghLogo)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configureTextField() {
        view.addSubview(usernameTextField)
        usernameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureGetFollowersButton() {
        view.addSubview(getFollowersButton)
        getFollowersButton.addTarget(self, action: #selector(pushFolloweList), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            getFollowersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            getFollowersButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            getFollowersButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            getFollowersButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func createDidmissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func pushFolloweList() {
        guard isUserNameEntered else {
            presentGFAlert(title: "Empty Username", message: "Enter username", buttonTitle: "OK")
            return
        }
        let followeListViewController = FollowerListViewController()
        followeListViewController.username = usernameTextField.text
        followeListViewController.title = usernameTextField.text
        navigationController?.pushViewController(followeListViewController, animated: true)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("DEBUG: \(textField.text ?? "")")
        pushFolloweList()
        return true
    }
}

#Preview {
    SearchViewController()
}
