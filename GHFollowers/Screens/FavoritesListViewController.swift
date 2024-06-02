//
//  FavoritesListViewController.swift
//  GHFollowers
//
//  Created by Він on 30.05.2024.
//

import UIKit

class FavoritesListViewController: UIViewController {
    
    let tableView = UITableView()
    var favorites: [Follower] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.reuseID)
    }
    
    private func getFavorites() {
        Task {
            let favorites = try await PersistenceManager.retrieveFavorites()
            if favorites.isEmpty {
                showEmptyStateView(message: "No Favorites", view: self.view)
            } else {
                self.favorites = favorites
                tableView.reloadData()
                view.bringSubviewToFront(tableView)
            }
        }
    }

}

extension FavoritesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.reuseID) as! FavoriteTableViewCell
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let followerListViewController = FollowerListViewController()
        followerListViewController.username = favorite.login
        followerListViewController.title = favorite.login
        navigationController?.pushViewController(followerListViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let favorite = favorites[indexPath.row]
        favorites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        
        Task {
            do {
                try await PersistenceManager.updateWith(favorite: favorite, actionType: .remove)
            } catch let error as GFError {
                presentGFAlert(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
}
