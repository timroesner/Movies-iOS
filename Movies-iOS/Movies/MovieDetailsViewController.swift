//
//  MovieDetailsViewController.swift
//  Movies-iOS
//
//  Created by Tim Roesner on 9/16/17.
//  Copyright © 2017 Tim Roesner. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var coverWidth: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLbl.text = currentMovie.title
        descLbl.text = currentMovie.desc
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
        
        cover.sd_setImage(with: URL(string: currentMovie.cover), placeholderImage: #imageLiteral(resourceName: "MissingArtworkMovies"), options: [], completed: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let scale = screenWidth/1024
        coverWidth.constant = 350*scale
        descLbl.sizeToFit()
        titleLbl.sizeToFit()
    }

    @IBAction func playPresed(sender: UIButton){
        let playerVC = PlayerViewController()
        self.present(playerVC, animated: true, completion: nil)
    }

}
