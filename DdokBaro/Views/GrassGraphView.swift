//
//  grassGraphView.swift
//  DdokBaro
//
//  Created by daaan on 2023/07/30.
//

import UIKit

class GrassGraphView: UIView {
    var level: Int
    var colors = ["EBEDF0", "9BE9A8", "40C463", "30A14E", "216E39"]
    
    required init(frame: CGRect, level: Int) {
        self.level = level
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: rect.width, height: rect.height),
                                byRoundingCorners:.allCorners, cornerRadii: CGSize(width: rect.width / 6, height: rect.width / 6))
        UIColor(hexCode: colors[level]).setFill()
        path.fill()
        path.close()
    }
}

class ChartSquareView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: rect.width, height: rect.height),
                                byRoundingCorners:.allCorners, cornerRadii: CGSize(width: rect.width / 20, height: rect.width / 20))
        UIColor.white.setFill()
        path.fill()
        path.close()
    }
}
