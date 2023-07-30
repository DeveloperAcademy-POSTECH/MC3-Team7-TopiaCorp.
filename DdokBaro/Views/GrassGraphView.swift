//
//  grassGraphView.swift
//  DdokBaro
//
//  Created by daaan on 2023/07/30.
//

import UIKit

class GrassGraphView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: rect.width, height: rect.height),
                                byRoundingCorners:.allCorners, cornerRadii: CGSize(width: rect.width / 6, height: rect.width / 6))
        UIColor.lightGray.setFill()
        path.fill()
        path.close()
    }
}
