//
//  BoardCollectionCell.swift
//  Pinteresting
//
//  Created by Ty Daniels on 4/4/17.
//  Copyright © 2017 Ty Daniels. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Stevia
import SDWebImage

class BoardCollectionCell: UICollectionViewCell {
    //MARK: View assets
    var mainBackgroundView = UIView()
    var avatar: UIImageView = UIImageView()
    var tappableName = UILabel()
    var commentTextView = UITextView()
    var selectBtn = UIButton()
    
    //MARK: Reused variables
    var avatarString: String? = ""
    var name: String? = ""
    var commentString: String? = ""
    
    //MARK: If a GoogleRating object is given, store it's variables into reusable cell upon initilization
    var boardItem: BoardObject? {
        didSet{
            if let name = self.boardItem?.name {
                tappableName.text = name
                
                if let boardImg = boardItem?.imageURL {
                    self.avatar.sd_setImage(with: URL(string: boardImg), placeholderImage: UIImage(), options: [.refreshCached] )
                }
                self.commentTextView.text = boardItem?.description
            }
        }
    }
    
    //MARK: - Set up layouts for cell
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupView()
    }
    
    //MARK: - Initialization
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func setupView() {
        
        avatar.frame = contentView.bounds
        avatar.layer.cornerRadius = 25
        backgroundView = avatar
    }
}
