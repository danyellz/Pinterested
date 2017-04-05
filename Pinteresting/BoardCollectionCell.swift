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
    var avatar = UIImageView()
    var tappableName = UILabel()
    var descriptionLabel = UILabel()
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
                
                descriptionLabel.text = "No description"
                descriptionLabel.text = boardItem?.description
                
                if let boardImg = boardItem?.imageURL {
                    self.avatar.sd_setImage(with: URL(string: boardImg), placeholderImage: UIImage(), options: [.refreshCached] )
                }
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
        
        contentView.sv(avatar, descriptionLabel)
        contentView.layout(
            0,
            |-avatar-|,
            0,
            |-descriptionLabel-| ~ 20
        )
        
        avatar.width(80)
        avatar.height(80)
        avatar.layer.cornerRadius = 40
        avatar.centerHorizontally()
        
        descriptionLabel.backgroundColor = UIColor.clear
        descriptionLabel.textColor = UIColor.lightGray
        descriptionLabel.textAlignment = .center
        descriptionLabel.isUserInteractionEnabled = false
    }
}
