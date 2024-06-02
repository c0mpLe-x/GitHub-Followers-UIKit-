//
//  FollowerListViewControllerDelegate.swift
//  GHFollowers
//
//  Created by Він on 02.06.2024.
//

import Foundation

protocol FollowerListViewControllerDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}
