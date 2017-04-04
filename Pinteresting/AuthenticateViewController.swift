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
    
    var pinterestManager = PinterestManager()
    
    // MARK : View assets
    var authBtn = UIButton()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    fileprivate func setupView() {
        
        view.sv(authBtn)
        view.layout(
            0,
            |-authBtn-|
        )
        
        // Mark: Additional layouts
        view.backgroundColor = UIColor.lightGray
        
        authBtn.addTarget(self, action: #selector(attemptPinLogin), for: .touchUpInside)
        authBtn.width(50)
        authBtn.height(50)
        authBtn.centerVertically()
        authBtn.backgroundColor = UIColor.red
    }
    
    @objc fileprivate func attemptPinLogin() {
        pinterestManager.userAuthenticate(completionHandler: {(response) -> Void in
            if response! {
                self.pinterestManager.getUserBoards(completionHandler: {(boards) -> Void in
                    
                })
            }
        })
    }
}
