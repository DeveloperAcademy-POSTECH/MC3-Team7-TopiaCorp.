//
//  CircleView.swift
//  DdokBaro
//
//  Created by TopiaCorp. on 2023/07/16.
//

import UIKit

class CircleViewController : UIView{

    override func draw(_ rect: CGRect) {
            let ellipseRect = CGRect(x:0, y:0, width: 530, height: 177)
            
            let path = UIBezierPath(ovalIn: bounds)
            
            let shadowLayer = CALayer()
            shadowLayer.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: bounds.height / 2)
            shadowLayer.shadowColor = UIColor.systemGray.cgColor
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowOffset = CGSize(width: 4, height: 4)
            shadowLayer.shadowRadius = 13
            shadowLayer.masksToBounds = false
            
            layer.addSublayer(shadowLayer)
        
        let maskLayer = CAShapeLayer()
                maskLayer.path = path.cgPath
                layer.mask = maskLayer
                
                UIColor.yellow.setFill()
                path.fill()
    }
}
