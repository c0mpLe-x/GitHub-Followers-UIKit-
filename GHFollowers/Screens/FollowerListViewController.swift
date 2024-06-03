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
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
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
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchController
    }
    
    private func getFollowers(username: String)  {
        showLoadingView()
        Task {
            do {
                let followers = try await NetworkManager.shared.getFollowers(for: username, page: page)
                dismissLoadingView()
                if followers.count < 100 { hasMoreFollowers = false }
                self.followers.append(contentsOf: followers)
                if followers.isEmpty {
                    let message = "This user doesn`t have any followers"
                    showEmptyStateView(message: message, view: view)
                    navigationItem.searchController?.searchBar.isHidden = true
                }
                await updateData(on: followers)
            } catch {
                if let error = error as? GFError {
                    presentGFAlert(title: "We have a problem", message: error.rawValue, buttonTitle: "OK")
                } else {
                    presentDefaultAlert()
                    dismissLoadingView()
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
    
    @objc func addButtonTapped() {
        showLoadingView()
        Task {
            do {
                let user = try await NetworkManager.shared.getUserInfo(for: username)
                dismissLoadingView()
                let follower = Follower(login: user.login, avatarUrl: user.avatarUrl)
                try await PersistenceManager.updateWith(favorite: follower, actionType: .add)
                presentGFAlert(title: "🎉 New favorite", message: "You add \(follower.login) in favotite", buttonTitle: "OK")
            } catch let error as GFError {
                presentGFAlert(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
}

extension FollowerListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filterFollowers.removeAll()
            Task {
                await updateData(on: followers)
            }
            isSearching = false
            return
        }
        isSearching = true
        filterFollowers = followers.filter({ $0.login.lowercased().contains(filter.lowercased()) })
        Task {
            await updateData(on: filterFollowers)
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
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username)
    }
}


#Preview {
    FollowerListViewController(username: "Test")
}
