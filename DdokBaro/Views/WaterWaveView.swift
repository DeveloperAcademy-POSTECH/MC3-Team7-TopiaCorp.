//
//  WaterWaveView.swift
//  DdokBaro
//
//  Created by daaan on 2023/07/22.
//

import UIKit
import UserNotifications

let screenWidth = UIScreen.main.bounds.size.width

class WaterWaveView: UIView {
    private let firstWave = CAShapeLayer()
    private let secondWave = CAShapeLayer()
    private let percentLabel = UILabel()
    
    private var firstColor: UIColor = .clear
    private var secondColor: UIColor = .clear
    
    private let doublePi: CGFloat = .pi * 2
    private var offset: CGFloat = 0.0
    
    private let width = screenWidth * 0.5
    
    var showSingleWave = false
    private var start = false
    
    var progress: CGFloat = 0.0
    var waveHeight: CGFloat = 0.0
    
    var check50:Bool = true
    var check20:Bool = true
    var check10:Bool = true
    var check0:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension WaterWaveView {
    private func setupViews() {
        let dropLetView = DropletView(frame: CGRect(x: 0.0, y: 0.0, width: min(width, width), height: min(width, width)))
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        dropLetView.layer.masksToBounds = true
        dropLetView.backgroundColor = UIColor(hexCode: "DFE8FB")

        addSubview(dropLetView)
        dropLetView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dropLetView.widthAnchor.constraint(equalToConstant: min(width, width)),
            dropLetView.heightAnchor.constraint(equalToConstant: min(width, width)),
            dropLetView.centerXAnchor.constraint(equalTo: centerXAnchor),
            dropLetView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        bounds = CGRect(x: 0.0, y: 0.0, width: min(width, width), height: min(width, width))
        clipsToBounds = true
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        layer.masksToBounds = true
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
        
        waveHeight = 8.0
        firstColor = UIColor(hexCode: "367AF6")
        secondColor = UIColor(hexCode: "367AF6").withAlphaComponent(0.4)
        createFirstWave()
        
        if !showSingleWave {
            createSecondWave()
        }
        createPercentLabel()
    }
    
    private func createFirstWave() {
        firstWave.frame = bounds
        firstWave.anchorPoint = .zero
        firstWave.fillColor = firstColor.cgColor
        layer.addSublayer(firstWave)
    }
    
    private func createSecondWave() {
        secondWave.frame = bounds
        secondWave.anchorPoint = .zero
        secondWave.fillColor = secondColor.cgColor
        layer.addSublayer(secondWave)
    }
    
    private func createPercentLabel() {
        percentLabel.font = UIFont.boldSystemFont(ofSize: 35.0)
        percentLabel.text = ""
        percentLabel.textColor = .darkGray
        addSubview(percentLabel)
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        //waterWaveView 가로 세로 중앙에 배치
        percentLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        percentLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func percentAnim() {
        let anim = CABasicAnimation(keyPath: "opacity")//애니메이션 속성은 투명도 조절이다.
        anim.duration = 1.5 //지속시간
        anim.fromValue = 0.0 //투명도 0.0으로 시작
        anim.toValue = 1.0 //투명도 목표 값
        anim.repeatCount = .infinity
        anim.isRemovedOnCompletion = false //애니메이션이 완료되었을 때 레이어에서 제거?
        
        percentLabel.layer.add(anim, forKey: nil)
    }
    
    func setupProgress(_ pr: CGFloat) {
        progress = pr
        percentLabel.text = "\(Int(100 * progress))L"
        percentLabel.textColor = .white
        if Int(100 * progress) == 50 {
            if check50 == true {
                NotificationManager().scheduleNotification50()
                check50 = false
                check0 = true
            }
            else{
                
            }
        }
        if Int(100 * progress) == 20 {
            if check20 == true {
                NotificationManager().scheduleNotification20()
                check20 = false
            }
            else{
                
            }
        }
        if Int(100 * progress) == 10 {
            if check10 == true {
                NotificationManager().scheduleNotification10()
                check10 = false
            }
            else{
                
            }
        }
        if Int(100 * progress) == 0 {
            if check0 == true {
                NotificationManager().scheduleNotification0()
                check0 = false
            }
            else{
                
            }
        }
        let top: CGFloat = pr * bounds.size.height
        //print(top)
        firstWave.setValue((width - top + 72) * 0.6, forKeyPath: "position.y")
        secondWave.setValue((width - top + 72) * 0.6, forKeyPath: "position.y")
        
        if !start {
            DispatchQueue.main.async {
                self.startAnim()
            }
        }
    }
    
    private func startAnim() {
        start = true
        waterWaveAnim()
    }
    
    private func waterWaveAnim() {
        let w = bounds.size.width
        let h = bounds.size.height
        
        let bezier = UIBezierPath()
        let path = CGMutablePath()
        
        let startOffsetY = waveHeight * CGFloat(sinf(Float(offset * doublePi / w)))
        var originOffsetY: CGFloat = 0.0
        
        path.move(to: CGPoint(x: 0.0, y: startOffsetY), transform: .identity)
        bezier.move(to: CGPoint(x: 0.0, y: startOffsetY))
        
        for i in stride(from: 0.0, to: w * 1000, by: 1) {
            originOffsetY = waveHeight * CGFloat(sinf(Float(doublePi / w * i + offset * doublePi / w)))
            bezier.addLine(to: CGPoint(x: i, y: originOffsetY))
        }
        
        bezier.addLine(to: CGPoint(x: w * 1000, y: originOffsetY))
        bezier.addLine(to: CGPoint(x: w * 1000, y: h))
        bezier.addLine(to: CGPoint(x: 0.0, y: h))
        bezier.addLine(to: CGPoint(x: 0.0, y: startOffsetY))
        bezier.close()
        
        let anim = CABasicAnimation(keyPath: "transform.translation.x")
        anim.duration = 2.0
        anim.fromValue = -w * 0.5
        anim.toValue = -w - w * 0.5
        anim.repeatCount = .infinity
        anim.isRemovedOnCompletion = false
        
        firstWave.fillColor = firstColor.cgColor
        firstWave.path = bezier.cgPath
        firstWave.add(anim, forKey: nil)
        
        if !showSingleWave {
            let bezier = UIBezierPath()
            
            let startOffsetY = waveHeight * CGFloat(sinf(Float(offset * doublePi / w)))
            var originOffsetY: CGFloat = 0.0
            
            path.move(to: CGPoint(x: 0.0, y: startOffsetY), transform: .identity)
            bezier.move(to: CGPoint(x: 0.0, y: startOffsetY))
            
            for i in stride(from: 0.0, to: w * 1000, by: 1) {
                originOffsetY = waveHeight * CGFloat(cosf(Float(doublePi / w * i + offset * doublePi / w)))
                bezier.addLine(to: CGPoint(x: i, y: originOffsetY))
            }
            
            bezier.addLine(to: CGPoint(x: w * 1000, y: originOffsetY))
            bezier.addLine(to: CGPoint(x: w * 1000, y: h))
            bezier.addLine(to: CGPoint(x: 0.0, y: h))
            bezier.addLine(to: CGPoint(x: 0.0, y: startOffsetY))
            bezier.close()
            
            secondWave.fillColor = secondColor.cgColor
            secondWave.path = bezier.cgPath
            secondWave.add(anim, forKey: nil)
        }
    }
}
