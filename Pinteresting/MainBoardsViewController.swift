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
    
    var boardsTable = UITableView()
    
    // MARK : View data
    var boardsArr = [BoardObject]() {
        didSet {
            boardsTable.reloadData()
        }
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        boardsTable.delegate = self
        boardsTable.dataSource = self
        boardsTable.register(BoardCell.self, forCellReuseIdentifier: "BoardCell")
        
        setupView()
        getBoards()
    }
    
    fileprivate func setupView() {
        view.sv(boardsTable)
        view.layout(
            0,
            |boardsTable| ~ view.frame.height
        )
        
        view.backgroundColor = UIColor.orange
    }
    
    fileprivate func getBoards() {
        pinterestManager.getUserBoards(completionHandler: {(boards) -> Void in
            print(boards)
            self.boardsArr = boards!
        })
    }
}

extension MainBoardsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}

extension MainBoardsViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
            return boardsArr.count 
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardCell") as! BoardCell
        cell.boardItem = boardsArr[indexPath.row]
        return cell
    }
}
