//
//  CircleView.swift
//  DdokBaro
//
//  Created by TopiaCorp. on 2023/07/16.
//

import UIKit

class CircleViewController: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        let _: CGFloat = 390
        let height: CGFloat = 250
        
        let y: CGFloat = 65
        let curveTo: CGFloat = 0
        
        let myBezier = UIBezierPath()
        myBezier.move(to: CGPoint(x: 0, y: y))
        myBezier.addQuadCurve(to: CGPoint(x: bounds.width, y: y), controlPoint: CGPoint(x: bounds.width / 2, y: curveTo))
        myBezier.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        myBezier.addLine(to: CGPoint(x: 0, y: bounds.height))
        myBezier.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = myBezier.cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
       
        let shadowPath = UIBezierPath(cgPath: myBezier.cgPath)
        shapeLayer.shadowPath = shadowPath.cgPath
        
        shapeLayer.shadowOffset = CGSize(width: 0, height: -height / 12)
        shapeLayer.shadowOpacity = 0.5
        shapeLayer.shadowRadius = 13
        shapeLayer.shadowColor = UIColor(red: 0.243, green: 0.416, blue: 0.906, alpha: 0.1).cgColor
        
        
        self.layer.addSublayer(shapeLayer)
    }
}


    
    
    
    


