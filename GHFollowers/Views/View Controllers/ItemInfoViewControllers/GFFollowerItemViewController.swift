//
//  GFFollowerItemViewController.swift
//  GHFollowers
//
//  Created by Він on 02.06.2024.
//

import Foundation

class GFFollowerItemViewController: UserItemInfoViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    override func actionButtonTapped() {
        delegate?.didTapGitFollowers(for: user)
    }
}
