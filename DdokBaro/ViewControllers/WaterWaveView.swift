//
//  WaterWaveView.swift
//  DdokBaro
//
//  Created by daaan on 2023/07/22.
//

import UIKit

class WaterWaveView: UIView {
    private var firstWave = CAShapeLayer() //물결 2개
    private var secondWave = CAShapeLayer()
    private let percentLabel = UILabel() //백분율 표시
    
    private var firstColor: UIColor = .clear
    private var secondColor: UIColor = .clear
    
    private let twoPi: CGFloat = .pi * 2 //파동 계산
    private var offset: CGFloat = 0.0 //웨이브의 초기 위상 오프셋
    private var start = false //웨이브 애니메이션 시작?
    
    var progress: Int = 0 //웨이브 애니메이션의 진행
    var waveHeight: CGFloat = 0.0 //물결 사이 간격
    
//MARK: - Initializes
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension WaterWaveView {
    private func setupViews() {
        //뷰의 내용물 크기, 위치 정의
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
        waveHeight = 8.0
        firstColor = UIColor(hexCode: "367AF6")
        secondColor = UIColor(hexCode: "367AF6").withAlphaComponent(0.4)
        
        createFirstWave()
        creatSecondWave()
        createPercentLb1()
    }
    
    private func createFirstWave(){
        firstWave.frame = bounds
        firstWave.anchorPoint = .zero //기준점
        firstWave.fillColor = firstColor.cgColor
        layer.addSublayer(firstWave)
    }
    private func creatSecondWave(){
        secondWave.frame = bounds
        secondWave.anchorPoint = .zero
        secondWave.fillColor = secondColor.cgColor
        layer.addSublayer(secondWave)
    }
    private func createPercentLb1() {
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
    //progress 업데이트, percentLb1 레이블의 텍스트를 형식화된 백분율 값으로 설정
    func setupProgress(_ pr : CGFloat) {
        progress = Int(pr) //현재 진행 값을 추적하고 저장
        percentLabel.text = "\(Int(progress))L"
        
        let top: CGFloat = pr * bounds.size.height / 140.0
        
        firstWave.setValue(frame.width-top - 20, forKeyPath: "position.y")
        secondWave.setValue(frame.width-top - 20, forKeyPath: "position.y")
        
        //start가 false면 애니메이션 호출
        if !start{
            DispatchQueue.main.async {
                self.startAnim()
            }
        }
    }
    
    private func startAnim() { //start-> false : 물결 2개 애니메이션
        start = true
        waterWaveAnim()
    }
    
    func waterWaveAnim() {
        let w = bounds.size.width
        let h = bounds.size.height
        
        let firstBezier = UIBezierPath()
        let path = CGMutablePath()
        
        let firstStartOffsetY = waveHeight * CGFloat(sinf(Float(offset * twoPi / w)))
        var firstOriginOffsetY: CGFloat = 0.0
        
        path.move(to: CGPoint(x: 0.0, y: firstStartOffsetY),transform: .identity)
        firstBezier.move(to: CGPoint(x: 0.0, y: firstStartOffsetY))
        
        //파동 경로
        for i in stride(from: 0.0, to: w*1000, by: 1){
            firstOriginOffsetY = waveHeight * CGFloat(sinf(Float(twoPi / w * i + offset * twoPi / w)))
            firstBezier.addLine(to: CGPoint(x: i, y: firstOriginOffsetY))
        }
        //경로의 각 점
        firstBezier.addLine(to: CGPoint(x: w*1000, y: firstOriginOffsetY))
        firstBezier.addLine(to: CGPoint(x: w*1000, y: h))
        firstBezier.addLine(to: CGPoint(x: 0.0, y: h))
        firstBezier.addLine(to: CGPoint(x: 0.0, y: firstStartOffsetY))
        firstBezier.close()
        //x축으로 이동하는 변환에 대한 애니메이션을 설정
        let anim = CABasicAnimation(keyPath: "transform.translation.x")
        anim.duration = 2.0
        anim.fromValue = -w*0.5
        anim.toValue = -w - w*0.5
        anim.repeatCount = .infinity
        anim.isRemovedOnCompletion = false
        
        firstWave.fillColor = firstColor.cgColor
        firstWave.path = firstBezier.cgPath
        firstWave.add(anim, forKey: nil)
        
        let secondBezier = UIBezierPath()
        let secondStartOffsetY = waveHeight * CGFloat(sinf(Float(offset * twoPi / w)))
        var secondOriginOffsetY: CGFloat = 0.0
        
        secondBezier.move(to: CGPoint(x: 0.0, y: secondStartOffsetY))
        
        for i in stride(from: 0.0, to: w*1000, by: 1){
            secondOriginOffsetY = waveHeight * CGFloat(cosf(Float(twoPi / w * i + offset * twoPi / w)))
            secondBezier.addLine(to: CGPoint(x: i, y: secondOriginOffsetY))
        }
        
        secondBezier.addLine(to: CGPoint(x: w*1000, y: secondOriginOffsetY))
        secondBezier.addLine(to: CGPoint(x: w*1000, y: h))
        secondBezier.addLine(to: CGPoint(x: 0.0, y: h))
        secondBezier.addLine(to: CGPoint(x: 0.0, y: secondStartOffsetY))
        secondBezier.close()
        
        secondWave.fillColor = secondColor.cgColor
        secondWave.path = secondBezier.cgPath
        secondWave.add(anim, forKey: nil)
    }
}
