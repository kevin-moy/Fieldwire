//
//  PhotoCell.swift
//  Fieldwire
//
//  Created by Kevin on 3/7/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    
    func setupCell(photo: PhotoObject) {
        let url = URL(string: photo.urlString!)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                if data != nil {
                    self.photoImage.image = UIImage(data: data!)
                }
            }
        }
    }
}
