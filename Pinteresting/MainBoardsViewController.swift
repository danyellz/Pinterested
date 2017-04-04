//
//  MainBoardsViewController.swift
//  Pinteresting
//
//  Created by Ty Daniels on 4/4/17.
//  Copyright © 2017 Ty Daniels. All rights reserved.
//

import Foundation
import UIKit
import Stevia

class MainBoardsViewController: UIViewController {
    // MARK : Network managers
    var pinterestManager = PinterestManager()
    
    // MARK : View data
    var boardsArr = [BoardObject]()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        getBoards()
    }
    
    fileprivate func setupView() {
        view.sv()
        view.layout()
        
        view.backgroundColor = UIColor.orange
    }
    
    fileprivate func getBoards() {
        pinterestManager.getUserBoards(completionHandler: {(boards) -> Void in
            print(boards)
            self.boardsArr = boards!
        })
    }
}
