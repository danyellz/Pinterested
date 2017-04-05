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

class BoardCell: UITableViewCell {
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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    func setupView() {
        self.contentView.sv(mainBackgroundView)
        mainBackgroundView.sv(avatar, tappableName, selectBtn, commentTextView)
        
        self.contentView.layout(
            0,
            |-mainBackgroundView-| ~ self.contentView.frame.height
        )
        
        mainBackgroundView.layout(
            10,
            |-avatar-tappableName-|,
            -30,
            |-70-commentTextView-| ~ 40 //Left offset is relative to avatar width
            
        )
        
        mainBackgroundView.backgroundColor = UIColor.white
        
        avatar.backgroundColor = UIColor.lightGray
        avatar.height(60)
        avatar.width(60)
        avatar.layer.cornerRadius = 14.5
        avatar.layer.shadowColor = UIColor.black.cgColor
        avatar.layer.shadowOpacity = 1
        avatar.layer.shadowOffset = .zero
        avatar.layer.shadowRadius = 10
        
        tappableName.height(20)
        tappableName.top(-10)
        tappableName.font = UIFont.boldSystemFont(ofSize: 22)
        tappableName.backgroundColor = UIColor.clear
        tappableName.textColor = UIColor.black
        
        commentTextView.backgroundColor = UIColor.clear
        commentTextView.isUserInteractionEnabled = false
        commentTextView.textColor = UIColor.lightGray
        commentTextView.font = UIFont.boldSystemFont(ofSize: 12)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        tappableName.text = ""
        avatar.image = nil
        avatar.isHidden = false
        avatar.sd_cancelCurrentImageLoad()
    }

}
