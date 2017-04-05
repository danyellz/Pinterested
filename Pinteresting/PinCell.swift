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
    var commentTextView = UITextView()
    var selectBtn = UIButton()
    var rightArrowView = UIImageView(image: UIImage(named: "arrow-point-to-right"))
    
    //MARK: Reused variables
    var avatarString: String? = ""
    var name: String? = ""
    var commentString: String? = ""
    
    //MARK: If a GoogleRating object is given, store it's variables into reusable cell upon initilization
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
        
        insertGradientLayer()
        
        mainBackgroundView.backgroundColor = UIColor.clear
        
        avatar.layer.shadowColor = UIColor.black.cgColor
        avatar.layer.shadowOpacity = 1
        avatar.layer.shadowOffset = .zero
        avatar.layer.shadowRadius = 10
        
        tappableName.font = UIFont.boldSystemFont(ofSize: 26)
        tappableName.backgroundColor = UIColor.clear
        tappableName.textColor = UIColor.red
        
        commentTextView.backgroundColor = UIColor.clear
        commentTextView.isUserInteractionEnabled = false
        commentTextView.textColor = UIColor.black
        commentTextView.font = UIFont.boldSystemFont(ofSize: 14)
        
        rightArrowView.width(30)
    }
    
    //Gradient for image or mask overlay effect
    func insertGradientLayer() {
        gradient.frame = contentView.bounds
        gradient.colors = [UIColor.groupTableViewBackground.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.0, 0.8]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        contentView.layer.insertSublayer(gradient, at: 0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        gradient.removeFromSuperlayer()
        tappableName.text = ""
        avatar.image = nil
        avatar.isHidden = false
        avatar.sd_cancelCurrentImageLoad()
    }

}
