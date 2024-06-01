//
//  AvatarImageView.swift
//  GHFollowers
//
//  Created by Він on 31.05.2024.
//

import UIKit

class AvatarImageView: UIImageView {
    let cache = NetworkManager.shared.cache
    let placeholderImage = UIImage(resource: .avatarPlaceholder)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(from url: URL) {
        Task {
            if let image = cache.object(forKey: url as NSURL) {
                print("CACHE: I am have image with: \(url)")
                self.image = image
            } else {
                print("URL: I am download image with: \(url)")
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let uiImage = UIImage(data: data) else { return }
                cache.setObject(uiImage, forKey: url as NSURL)
                self.image = uiImage
            }
            
        }
    }
}
