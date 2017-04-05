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
    var boardCollectionView: UICollectionView!
    
    // MARK : View data
    var boardsArr = [BoardObject]() {
        didSet {
            boardCollectionView.reloadData()
        }
    }
    var feedItems = [PinObject]() {
        didSet {
            boardsTable.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .automatic)
        }
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        boardCollectionView.delegate = self
        boardCollectionView.dataSource = self
        boardCollectionView.register(BoardCollectionCell.self, forCellWithReuseIdentifier: "Cell")
        
        boardsTable.delegate = self
        boardsTable.dataSource = self
        boardsTable.register(UITableViewCell.self, forCellReuseIdentifier: "BoardCell")
        boardsTable.register(PinCell.self, forCellReuseIdentifier: "PinCell")
        
        setupView()
        getBoards()
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
     - 2. Layout views within the top view with UIView.layout()
     */
    fileprivate func setupView() {
        view.sv(boardsTable)
        view.layout(
            0,
            |boardsTable| ~ view.frame.height
        )
        
        view.backgroundColor = UIColor.white
    }
    
    fileprivate func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        boardCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0,
                                            width: view.frame.size.width,
                                            height: view.frame.size.height / 6),
                                            collectionViewLayout: layout)
        layout.itemSize = CGSize(width: boardCollectionView.frame.size.width / 3, height: view.frame.size.height / 6)
    }
    
    // MARK : Get user's boards
    fileprivate func getBoards() {
        pinterestManager.getUserBoards(completionHandler: {(boards) -> Void in
            self.boardsArr = boards!
        })
        
        pinterestManager.getFeedItems(completionHandler: {(feedPins) -> Void in
            self.feedItems = feedPins!
        })
    }
}

// MARK: UITableview Protocols

extension MainBoardsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 6
    }
}

extension MainBoardsViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return feedItems.count
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BoardCell")! as UITableViewCell
            cell.contentView.backgroundColor = UIColor.white
            cell.contentView.addSubview(boardCollectionView)
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PinCell") as! PinCell
            cell.pinItem = feedItems[indexPath.row]
            return cell
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Boards"
        case 1:
            return "Pin Feed"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.backgroundView?.backgroundColor = UIColor.white
            headerView.textLabel?.textColor = UIColor.red
            headerView.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            headerView.textLabel?.textAlignment = .center
            headerView.textLabel?.backgroundColor = UIColor.clear
        }
    }

}

// MARK : UICollectionView Protocols

//TODO: write tutorial for using collectionview delegate methods in tableview cell
extension MainBoardsViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boardsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! BoardCollectionCell
        cell.backgroundColor = UIColor.lightGray
        cell.boardItem = boardsArr[indexPath.row]
        return cell
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        
        if parent == nil {
            navigationController?.isNavigationBarHidden = true
        }
    }
    
}

extension MainBoardsViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 3
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}
