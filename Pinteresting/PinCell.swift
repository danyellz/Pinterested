//
//  BoardCell.swift
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

class PinCell: UITableViewCell {
    
    //MARK: View assets
    var gradient = CAGradientLayer()
    var mainBackgroundView = UIView()
    var avatar = UIImageView()
    var tappableName = UILabel()
    var commentTextView = UILabel()
    var selectBtn = UIButton()
    var rightArrowView = UIImageView(image: UIImage(named: "arrow-point-to-right"))
    
    //MARK: Reused variables
    var avatarString: String? = ""
    var name: String? = ""
    var commentString: String? = ""
    
    //MARK: If a PinObject object is not empty, utilize it's available variables into reusable cell assets upon initilization
    var pinItem: PinObject? {
        didSet{
            if let name = self.pinItem?.creatorName {
                tappableName.text = name
                
                if let boardImg = pinItem?.imageURL {
                    self.avatar.sd_setImage(with: URL(string: boardImg), placeholderImage: UIImage(), options: [.refreshCached] )
                }
                self.commentTextView.text = pinItem?.description
            }
        }
    }
    
    //MARK: - Set up layouts for cell
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.selectionStyle = .none
        
        setupView()
    }
    
    //MARK: - Initialization
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
    func setupView() {
        avatar.frame = contentView.bounds
        backgroundView = avatar
        
        contentView.sv(mainBackgroundView)
        contentView.layout(
            0,
            |-mainBackgroundView-| ~ self.contentView.frame.height - 20
        )
        
        mainBackgroundView.sv(tappableName, selectBtn, commentTextView, rightArrowView)
        mainBackgroundView.layout(
            (contentView.frame.height / 2),
            |-tappableName-rightArrowView| ~ 30,
            0,
            |-commentTextView-| ~ 40 //Left offset is relative to avatar width
            
        )
        
        // MARK : Additional layouts
        
        insertGradientLayer() //Adds gradient layer
        
        mainBackgroundView.backgroundColor = UIColor.clear
        
        avatar.layer.shadowColor = UIColor.black.cgColor
        avatar.layer.shadowOpacity = 1
        avatar.layer.shadowOffset = .zero
        avatar.layer.shadowRadius = 10
        
        tappableName.font = UIFont.boldSystemFont(ofSize: 22)
        tappableName.backgroundColor = UIColor.clear
        tappableName.textColor = UIColor.red
        
        commentTextView.backgroundColor = UIColor.clear
        commentTextView.textColor = UIColor.black
        commentTextView.font = UIFont.boldSystemFont(ofSize: 14)
        
        rightArrowView.width(30) // NOTE : ^Makes right arrow width equal to height set via Stevia layouts ^
    }
    
    //Gradient for image or mask overlay effect
    func insertGradientLayer() {
        gradient.frame = contentView.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.0, 0.8]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        contentView.layer.insertSublayer(gradient, at: 0)
    }
    
    //Reset assets for cell to be used as new
    override func prepareForReuse() {
        super.prepareForReuse()
        
        gradient.removeFromSuperlayer()
        tappableName.text = ""
        avatar.image = nil
        avatar.isHidden = false
        avatar.sd_cancelCurrentImageLoad()
    }

}
