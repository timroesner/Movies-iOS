//
//  FirstViewController.swift
//  Movies-iOS
//
//  Created by Tim Roesner on 9/16/17.
//  Copyright © 2017 Tim Roesner. All rights reserved.
//

import UIKit
import SDWebImage

var movies:[movie] = []
var currentMovie = movie(title : "", cover : "", desc : "", link : "", year: "", index: 0)
let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

class movie {
    let title : String
    let cover : String
    let desc : String
    let link : String
    let year : String
    let index : Int
    
    init(title : String, cover : String, desc : String, link : String, year: String, index: Int) {
        self.title = title
        self.cover = cover
        self.desc = desc
        self.link = link
        self.year = year
        self.index = index
    }
}

class FullViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: .UIApplicationDidBecomeActive, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    @objc func refreshData() {
        let url = URL(string: "http://timsvideos.x10host.com/videos.php")
        
        do {
            var counter = 0;
            movies.removeAll()
            let data = try NSData(contentsOf: url!, options: NSData.ReadingOptions.mappedIfSafe)
            let JSON = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
            if let dictionary = JSON as? [String: Any] {
                while(dictionary["\(counter)"] as? [String: Any] != nil){
                    let nestedDic = dictionary["\(counter)"] as? [String: Any]
                    let tmpMovie = movie(title : (nestedDic!["title"] as? String)!, cover : (nestedDic!["cover"] as? String)!, desc : (nestedDic!["desc"] as? String)!, link : (nestedDic!["link"] as? String)!, year: (nestedDic!["year"] as? String)!, index: counter)
                    movies.append(tmpMovie)
                    counter += 1
                }
            }
            self.collectionView?.reloadData()
        } catch let error as NSError {
            print("Error: \(error)")
            
            let alertController = UIAlertController(title: "No Internet Connection", message: "Seems like you are not connected to the internet. Check your connection.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            alertController.show(alertController, sender: self)
        }
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
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! FullCollectionViewCell
        let movieForCell = movies[indexPath.row]
        cell.title.text = movieForCell.title
        cell.thumbnail.sd_setImage(with: URL(string: movieForCell.cover), placeholderImage: #imageLiteral(resourceName: "MissingArtworkMovies"), options: [], completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentMovie = movies[indexPath.row]
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "movieDetails") as! MovieDetailsViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

