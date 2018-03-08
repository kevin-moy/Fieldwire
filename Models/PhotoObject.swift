//
//  PhotoObject.swift
//  Fieldwire
//
//  Created by Kevin on 3/7/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import Foundation

class PhotoObject {
    var urlString: String?
    
    convenience init(json: [String: Any]) {
        self.init()
        
        if let imageURLString = json["link"] {
            urlString = imageURLString as? String ?? ""
        }
    }
}
