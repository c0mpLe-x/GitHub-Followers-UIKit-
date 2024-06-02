//
//  UserInfoViewControllerDelegate.swift
//  GHFollowers
//
//  Created by Він on 02.06.2024.
//

import Foundation

protocol UserInfoViewControllerDelegate: AnyObject {
    func didTapGitHubProfile(for user: User)
    func didTapGitFollowers(for user: User)
}
