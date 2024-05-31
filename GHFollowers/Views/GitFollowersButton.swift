//
//  GitFollowersButton.swift
//  GHFollowers
//
//  Created by Він on 30.05.2024.
//

import UIKit

class GitFollowersButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
    }
    
    init(backgroundColor: UIColor, title: String) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 16
        titleLabel?.textColor = .white
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
