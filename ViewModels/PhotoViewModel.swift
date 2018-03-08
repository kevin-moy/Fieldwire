//
//  PhotoViewModel.swift
//  Fieldwire
//
//  Created by Kevin on 3/7/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import Foundation

class PhotoViewModel {
    var photos = [PhotoObject]()
    var currentOffset = 0
    var previousOffset = -1
    var currentPage = 0
    var requesting: Bool = false
    
    
    func clearFeed() {
        requesting = false
        photos = []
        currentOffset = 0
        previousOffset = -1
    }
    
    func imgurRequest(_ search: String?, page: Int, completionHandler:@escaping (_ succeed: Bool, _ total: Int?, _ error: String?) -> Void) {
        
        if requesting {
            completionHandler(false, nil, nil)
            return
        }
        
        if previousOffset == currentOffset {
            completionHandler(false, nil, nil)
            return
        }
        
        requesting = true
        ApiManager.sharedInstance.getPhotos(search, page) { (photos, error) in
            
            self.requesting = false
            if let fetchedPhotos = photos {
                self.photos.append(contentsOf: fetchedPhotos)
                self.previousOffset = self.currentOffset
                self.currentOffset = self.currentOffset + fetchedPhotos.count
                self.currentPage += 1
                completionHandler(true, fetchedPhotos.count, nil)
            }
            else {
                completionHandler(false, nil, error)
            }
        }
    }
}
