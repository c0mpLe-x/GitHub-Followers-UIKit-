//
//  UIHelper.swift
//  GHFollowers
//
//  Created by Він on 31.05.2024.
//

import UIKit

struct UIHelper {
    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width  = view.bounds.width
        let padding: CGFloat = 12
        let minItemSpace: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minItemSpace * 2)
        let itemWith = availableWidth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWith, height: itemWith + 40)
        
        return flowLayout
    }
}
