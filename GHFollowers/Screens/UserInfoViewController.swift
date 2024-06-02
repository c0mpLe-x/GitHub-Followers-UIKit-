//
//  UserInfoViewController.swift
//  GHFollowers
//
//  Created by Він on 02.06.2024.
//

import UIKit

class UserInfoViewController: UIViewController {
    var username: String!
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    var itemViews: [UIView] = []
    
    weak var delegate: FollowerListViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        layoutUI()
        fetchUserInfo()
    }
    
    private func layoutUI() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        
        itemViews.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                $0.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func fetchUserInfo() {
        Task {
            do {
                let user = try await NetworkManager.shared.getUserInfo(for: username)
                configureUIElements(with: user)
            } catch {
                if let error = error as? GFError {
                    presentGFAlert(title: "We have a problem with \(username!)", message: error.rawValue, buttonTitle: "OK")
                } else {
                    presentDefaultAlert()
                }
            }
        }
    }
    
    private func configureUIElements(with user: User) {
        let repoItemVC = GFRepoItemViewController(user: user)
        repoItemVC.delegate = self
        
        let followerItemVC = GFFollowerItemViewController(user: user)
        followerItemVC.delegate = self
        
        add(childViewController: GFUserInfoHeaderViewController(user: user), to: headerView)
        add(childViewController: repoItemVC, to: itemViewOne)
        add(childViewController: followerItemVC, to: itemViewTwo)
        dateLabel.text = "GitHub since \(user.createdAt.formatted(date: .abbreviated, time: .omitted))"
    }
    
    private func add(childViewController: UIViewController, to containerView: UIView) {
        addChild(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.view.frame = containerView.bounds
        childViewController.didMove(toParent: self)
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}

extension UserInfoViewController: UserInfoViewControllerDelegate {
    func didTapGitHubProfile(for user: User) {
        guard let url = user.htmlUrl else { 
            presentGFAlert(title: "Invalid user URL", message: "The URL attached to this user is invalid", buttonTitle: "OK")
            return
        }
        presentSafariViewController(with: url)
    }
    
    func didTapGitFollowers(for user: User) {
        guard user.followers != 0 else {
            presentGFAlert(title: "No followers", message: "This user has no followers", buttonTitle: "OK")
            return
        }
        delegate?.didRequestFollowers(for: user.login)
        dismissVC()
    }
    
    
}
