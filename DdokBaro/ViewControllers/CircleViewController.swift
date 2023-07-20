//
//  CircleView.swift
//  DdokBaro
//
//  Created by TopiaCorp. on 2023/07/16.
//

import UIKit

class CircleViewController: UIView {

    override func draw(_ rect: CGRect) {
        let y: CGFloat = 65
        let curveTo: CGFloat = 0
        let myBezier = UIBezierPath()
        myBezier.move(to: CGPoint(x: 0, y: y))
        myBezier.addQuadCurve(to: CGPoint(x: bounds.width, y: y), controlPoint: CGPoint(x: bounds.width / 2, y: curveTo))
        myBezier.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        myBezier.addLine(to: CGPoint(x: 0, y: bounds.height))
        myBezier.close()
        
        // 배경 색상 설정
        backgroundColor?.setFill()
        myBezier.fill()
        
        // 도형의 경로에 그림자 적용
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        context?.addPath(myBezier.cgPath)
        context?.setShadow(offset: CGSize(width: 0, height: -4), blur: 4.0, color: UIColor(red: 0.243, green: 0.416, blue: 0.906, alpha: 0.1).cgColor)
        context?.fillPath()
        context?.restoreGState()
    }
}


    
    
    
    


