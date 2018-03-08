//
//  ApiManager.swift
//  Fieldwire
//
//  Created by Kevin on 3/7/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import Foundation

class ApiManager {
    static let sharedInstance = ApiManager()
    
    func getPhotos(_ searchText: String!, _ page: Int, completionHandler:@escaping (_ photos: [PhotoObject]?, _ error: String?) -> Void) {
        
        let group = DispatchGroup()
        var photoArray = [PhotoObject]()
        let url = URL(string: Constants.imgurbaseURL+searchText+"&page=\(page)")
        
        var request = URLRequest(url: url!)
        request.setValue("Client-ID \(Constants.clientID)", forHTTPHeaderField: "Authorization")
        
        group.enter()
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error -> Void in
            
            guard error == nil else {
                print(error!)
                completionHandler(nil, error as! String?)
                return
            }
            guard data != nil else {
                print("Data is empty")
                return
            }
            
            if error != nil {
                print("Error fetching photos: \(String(describing: error))")
                return
            }
            
            do {
                let dictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                
                guard let photosDictionary = dictionary!["data"] as? [[String: Any]] else {
                    return
                }
                for photoData in photosDictionary {
                    if let image = photoData["images"] as? [[String: Any]] {
                        let newImage = image[0]
                        let photo = PhotoObject.init(json: newImage)
                         photoArray.append(photo)
                    }
                }
                completionHandler(photoArray, nil)
            } catch let error as NSError {
                print("Error parsing JSON: \(error)")
                return
            }
        })
        task.resume()
        group.notify(queue: .main) {
            completionHandler(photoArray, nil)
        }
    }
}

