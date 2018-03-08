//
//  ViewController.swift
//  Fieldwire
//
//  Created by Kevin on 3/7/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var photoFeed = PhotoViewModel()
    var userSearch: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func getImgurSearch() {
        photoFeed.imgurRequest(userSearch!, page: 0) { (success, total, error) in
            if success {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    if self.photoFeed.photos.count == 0 {
                        self.noResultsAlert()
                    }
                }
            }
            else if error != nil {
                self.noConnectionAlert()
            }
        }
    }
    
    func getMoreImages() {
        photoFeed.imgurRequest(userSearch!, page: photoFeed.currentPage) { (success, total, error) in
            if success {
                DispatchQueue.main.async {
                    let total = total
                    self.collectionView.performBatchUpdates({
                        var indexPaths = [IndexPath]()
                        for i in (self.photoFeed.currentOffset - total!)..<self.photoFeed.currentOffset {
                            let indexPath = IndexPath.init(item: i, section: 0)
                            indexPaths.append(indexPath)
                        }
                        self.collectionView.insertItems(at: indexPaths)
                    }, completion: { done -> Void in
                    })
                }
            }
            else if error != nil {
                self.noConnectionAlert()
            }
        }
    }
    
    func noConnectionAlert() {
        let alertController = UIAlertController.init(title: "Error", message: "No Internet connection. Please try again", preferredStyle: .alert)
        let okayAction = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func noResultsAlert() {
        let alertController = UIAlertController.init(title: "No Results", message: "", preferredStyle: .alert)
        let okayAction = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: SearchBar Functions
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchTerms = searchBar.text, searchTerms != "" {
            userSearch = searchTerms
        }
        collectionView.reloadData()
        photoFeed.clearFeed()
        self.getImgurSearch()
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        view.endEditing(true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        searchBar.showsCancelButton = true
        return true
    }

    // MARK: - CollectionView data source
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedRow = photoFeed.photos[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PhotoVC") as! PhotoViewController
        vc.photo = selectedRow
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoFeed.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        cell.setupCell(photo: self.photoFeed.photos[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.bounds.width, height: CGFloat(40))
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    // MARK: - ScrollView delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionView.bounds.intersects(CGRect(x: 0, y: collectionView.contentSize.height - ScreenSize.SCREEN_HEIGHT / 2, width: collectionView.frame.width, height: ScreenSize.SCREEN_HEIGHT / 2)) && collectionView.contentSize.height > 0 {
            getMoreImages()
        }
    }
}


