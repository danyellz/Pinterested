//
//  ShapedImageView.swift
//  Pinteresting
//
//  Created by Ty Daniels on 4/9/17.
//  Copyright © 2017 Ty Daniels. All rights reserved.
//

import Foundation
import UIKit

class ShapedImageView: UIImageView {
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    //    override func drawRect(rect: CGRect)
    //    {
    //
    //
    //    }
    
    
    override func setNeedsLayout() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height/2))
        path.addLine(to: CGPoint(x: self.frame.size.width/2, y: 0))
        path.addArc(withCenter: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2), radius: self.frame.size.width/2, startAngle:-CGFloat(M_PI), endAngle: CGFloat(M_PI), clockwise: false)
        
        path.move(to: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height))
        path.close()
        UIColor.red.setFill()
        path.stroke()
        path.reversing()
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        self.layer.mask = shapeLayer;
        self.layer.masksToBounds = true;
    }
    
}
