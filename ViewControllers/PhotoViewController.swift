//
//  PhotoViewController.swift
//  Fieldwire
//
//  Created by Kevin on 3/7/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    
    var photo: PhotoObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: photo.urlString!)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.photoImageView.image = UIImage(data: data!)
            }
        }
    }
}
