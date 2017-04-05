//
//  PinterestDetailViewController.swift
//  Pinteresting
//
//  Created by Ty Daniels on 4/4/17.
//  Copyright © 2017 Ty Daniels. All rights reserved.
//

import Foundation
import UIKit
import Stevia
import SDWebImage
import CoreLocation

class PinterestDetailViewController: UIViewController {
    // MARK : Reused Managers
    var pinObject: PinObject? = nil
    
    // MARK : View assets
    var titleView = UIView()
    var imageView = UIImageView()
    var nameLabel = UILabel()
    var descriptionView = UITextView()
    var cardView = UIView()
    
    // MARK: Controllers
    var reviewsTable = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Configure views
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //Initialize data from PinObject into assets.
        setupContainerData()
    }
    
    /*
     Setup views/containers. Using Stevia to configure layouts: a framework that is practical due to
     a more visually intuitive syntax. The basic usage of this framework involves setting a top constraint
     for every asset that is vertically aligned. Also, Stevia allows for positioning view objects horizontally
     aligned, and the sizes of each element become relative to one another based on percentages in relation to UIWindow sizes.
     Finally, |-asset-| spans the window with a small margin left/right. ~ is used to set an approximate
     height relative to window height.
     
     In order to use Stevia:
     - 1. Add subviews to corresponding views w/ UIView.sv(views)
     - 2. Layout subview orientation within the top view with UIView.layout([views])
     */
    fileprivate func setupView() {
        
        view.sv(titleView, cardView)
        view.layout(
            0,
            |titleView| ~ view.frame.height / 2,
            0,
            |cardView| ~ view.frame.height / 2
        )
        
        titleView.sv(imageView)
        
        cardView.sv(nameLabel, descriptionView)
        cardView.layout(
            0,
            |-nameLabel-| ~ 40,
            0,
            |-descriptionView-| ~ view.frame.height / 4
        )
        
        // MARK: Additional layout
        
        /*
         Custom blur effect for cardView. Slight overlap of titleView gives parallax effect.
         Ideally the cardView would be scrollable, minimizing the titleView frame.
         */
        let blurEffect: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        var blurEffectView: UIVisualEffectView = UIVisualEffectView()
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = cardView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cardView.insertSubview(blurEffectView, at: 0)
        cardView.backgroundColor = UIColor.clear
        
        imageView.frame = titleView.bounds
        imageView.centerHorizontally()
        
        cardView.backgroundColor = UIColor.lightGray
        nameLabel.backgroundColor = UIColor.clear
        
        nameLabel.textColor = UIColor.white
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        
        descriptionView.textColor = UIColor.darkGray
        descriptionView.backgroundColor = UIColor.clear
        descriptionView.font = UIFont.boldSystemFont(ofSize: 22)
        descriptionView.isEditable = false
    }
    
    // MARK: Function used to load data into view after layouts finish initializing
    fileprivate func setupContainerData() {
        nameLabel.text = "by: " + (pinObject?.creatorName)!
        descriptionView.text = "description: " + (pinObject?.description)!
        
        DispatchQueue.main.async {
            self.imageView.sd_setImage(with: URL(string: (self.pinObject?.imageURL)!),
                                  placeholderImage: nil,
                                  options: .refreshCached
            )
        }
    }
}
