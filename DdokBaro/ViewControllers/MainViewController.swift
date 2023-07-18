//
//  MainView.swift
//  DdokBaro
//
//  Created by 신서연 on 2023/07/14.
//

import UIKit

class MainViewController: UIViewController {
    

    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var bottomTitleLabel: UILabel!
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var circleView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTitleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        bottomTitleLabel.font =
            UIFont.boldSystemFont(ofSize: 28)
        setCircleViewShadow()
        setUpCircleView()
        
    }
    
    private func setCircleViewShadow() {
            circleView.layer.masksToBounds = false
            circleView.layer.shadowColor = UIColor.black.cgColor //그림자 색깔 : 검정색
            circleView.layer.shadowOpacity = 0.2 // 그림자 투명도 : 0~1, 0에 가까울 수록 투명해짐
            circleView.layer.shadowOffset = CGSize(width: 0, height: 0.3) // 그림자 위치 이동 : 밑으로 5 point 이동
            circleView.layer.shadowRadius = 1 // 그림자 굵기
            circleView.layer.shadowPath = UIBezierPath(arcCenter: CGPoint(x: circleView.bounds.width / 2, y: circleView.bounds.height / 2), radius: circleView.bounds.width / 2, startAngle: 0, endAngle: 2 * .pi, clockwise: true).cgPath //그림자 모양 : 그림자와 동일한 크기의 원형
        }
        
        private func setUpCircleView() {
            circleView.layer.cornerRadius = circleView.bounds.width / 2
            circleView.backgroundColor = .white
        }
}


