//
//  SecondViewController.swift
//  Movies-iOS
//
//  Created by Tim Roesner on 9/16/17.
//  Copyright © 2017 Tim Roesner. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filteredMovies = [movie]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.text = ""
        filteredMovies.removeAll()
        collectionView.reloadData()
        searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filteredMovies.removeAll()
        self.view.endEditing(true)
        searchBar.showsCancelButton = false
        for m in movies {
            if(m.title.contains(searchBar.text ?? "")){
                filteredMovies.append(m)
            }
        }
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var itemsPerRow = 5.0
        if(screenWidth<1000){
            itemsPerRow = 3
        }
        let w = Double(screenWidth)/itemsPerRow - 20
        let h = w*1.5+21
        return CGSize(width: w, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchCollectionViewCell
        let movieForCell = filteredMovies[indexPath.row]
        cell.title.text = movieForCell.title
        cell.thumbnail.sd_setImage(with: URL(string: movieForCell.cover), placeholderImage: #imageLiteral(resourceName: "MissingArtworkMovies"), options: [], completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentMovie = filteredMovies[indexPath.row]
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "movieDetails") as! MovieDetailsViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

