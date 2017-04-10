//
//  AuthenticateViewController.swift
//  Pinteresting
//
//  Created by Ty Daniels on 4/4/17.
//  Copyright © 2017 Ty Daniels. All rights reserved.
//

import Foundation
import UIKit
import Stevia

class AuthenticateViewController: UIViewController {
    // MARK : Network managers
    var pinterestManager = PinterestManager()
    
    // MARK : View assets
    var logoLabel = UILabel()
    var descView = UITextView()
    var authBtn = UIButton()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
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
     - 2. Layout subviews within the top view with UIView.layout()
     */
    fileprivate func setupView() {
        view.sv(logoLabel, descView, authBtn)
        view.layout(
            (view.frame.height / 6),
            |-logoLabel-| ~ 80,
            0,
            |-descView-| ~ 80,
            0,
            authBtn ~ 40
        )
        
        // Mark: Additional layouts
        
        navigationController?.isNavigationBarHidden = true // Hide nav
        
        view.backgroundColor = UIColor.white
        
        logoLabel.backgroundColor = UIColor.clear
        logoLabel.text = "Pinterested"
        logoLabel.textColor = UIColor.red
        logoLabel.font = UIFont.LilyScriptOne(sizeFont: 40)
        logoLabel.textAlignment = .center
        
        descView.text = "The semi live pin viewing feed. \n Emphasis on 'semi' ;)"
        descView.textColor = UIColor.lightGray
        descView.isUserInteractionEnabled = false
        descView.textAlignment = .center
        
        authBtn.width(200)
        authBtn.backgroundColor = UIColor.red
        authBtn.addTarget(self, action: #selector(attemptPinLogin), for: .touchUpInside)
        authBtn.setTitle("Get Pinterested", for: .normal)
        authBtn.centerVertically()
        authBtn.centerHorizontally()
    }
    
    //  MARK : Try to authenticate into Pinterest for SDK instance to access user data
    @objc fileprivate func attemptPinLogin() {
        pinterestManager.userAuthenticate(completionHandler: {(response) -> Void in
            if response! {
                let mainNavController = UINavigationController(rootViewController: MainBoardsViewController())
                self.present(mainNavController, animated: true, completion: nil)
            }
        })
    }
}
