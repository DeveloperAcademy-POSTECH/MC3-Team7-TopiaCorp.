//
//  DropletView.swift
//  DdokBaro
//
//  Created by daaan on 2023/07/22.
//

import UIKit

class DropletView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {

        guard let context = UIGraphicsGetCurrentContext() else {return}
         
        let width = rect.width
        let height = rect.height
        
        let center = CGPoint(x: width / 2, y: height / 2)
        let startPoint = CGPoint(x: width / 2, y: height / 20)
        
        context.move(to: startPoint)
        context.addArc(center: center, radius: width * 9 / (20 * sqrt(2.0)),
                       startAngle: 5 * (.pi / 4), endAngle: 7 * (.pi / 4), clockwise: true)
        context.addLine(to: startPoint)
        context.closePath()
        
        UIColor(hexCode: "367AF6").setStroke()
        context.setLineWidth(10)
        context.strokePath()
    }
}
