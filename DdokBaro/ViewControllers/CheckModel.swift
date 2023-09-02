//
//  CheckModel.swift
//  DdokBaro
//
//  Created by yusang on 2023/08/21.
//

import Foundation

class CheckModel {
    //static let shared = ZeroCheckModel()

    private init() {}

    @objc dynamic var zeroCheck:Bool = false {
        didSet {
            // airPodCheck의 값이 변경될 때마다 호출되는 코드
            // NotificationCenter를 이용하여 값을 알린다
            NotificationCenter.default.post(name: NSNotification.Name("zerocheck"), object: nil)
        }
    }

    func updateValue(newValue: Bool) {
        zeroCheck = newValue
    }
}
