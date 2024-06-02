//
//  FollowerListViewController.swift
//  GHFollowers
//
//  Created by Він on 30.05.2024.
//

import UIKit

class FollowerListViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var username: String!
    var followers: [Follower] = []
    var filterFollowers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers(username: username)
        configureDataSource()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchController
    }
    
    private func getFollowers(username: String)  {
        showLoadingView()
        Task {
            do {
                let followers = try await NetworkManager.shared.getFollowers(for: username, page: page)
                await dismissLoadingView()
                if followers.count < 100 { hasMoreFollowers = false }
                self.followers.append(contentsOf: followers)
                if followers.isEmpty {
                    let message = "This user doesn`t have any followers"
                    showEmptyStateView(message: message, view: view)
                }
                await updateData(on: followers)
            } catch {
                if let error = error as? GFError {
                    presentGFAlert(title: "We have a problem", message: error.rawValue, buttonTitle: "OK")
                } else {
                    presentDefaultAlert()
                }
            }
        }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    private func updateData(on followers: [Follower]) async {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        await dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension FollowerListViewController: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers else { return }
            page += 1
            getFollowers(username: username)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filterFollowers : followers
        let follower = activeArray[indexPath.item]
        
        let userInfoViewController = UserInfoViewController()
        userInfoViewController.username = follower.login
        userInfoViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: userInfoViewController)
        present(navigationController, animated: true)
    }
}

extension FollowerListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true
        filterFollowers = followers.filter({ $0.login.lowercased().contains(filter.lowercased()) })
        Task {
            await updateData(on: filterFollowers)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel button clicked")
        isSearching = false
        Task {
            await updateData(on: followers)
        }
    }
}

extension FollowerListViewController: FollowerListViewControllerDelegate {
    func didRequestFollowers(for username: String) {
        self.username = username
        title = username
        followers.removeAll()
        filterFollowers.removeAll()
        page = 1
        collectionView.setContentOffset(.zero, animated: true)
        getFollowers(username: username)
    }
    
    
}


#Preview {
    FollowerListViewController()
}
