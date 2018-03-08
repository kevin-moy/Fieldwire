//
//  Extensions.swift
//  Fieldwire
//
//  Created by Kevin on 3/7/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

var itemsPerRow: CGFloat = 2
let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

extension ViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var widthPerItem: CGFloat
        widthPerItem = getWidth()
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    func getWidth() -> CGFloat {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return widthPerItem
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}


