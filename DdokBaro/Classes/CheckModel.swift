//
//  CheckModel.swift
//  DdokBaro
//
//  Created by yusang on 2023/08/21.
//

import Foundation

class CheckModel {

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

class AirPodCheckModel {
    static let shared = AirPodCheckModel()

    private init() {}

    @objc dynamic var airPodCheck:Bool = false {
        didSet {
            // airPodChec의 값이 변경될 때마다 호출되는 코드
            // NotificationCenter를 이용하여 값을 알린다
            NotificationCenter.default.post(name: NSNotification.Name("airpodcheck"), object: nil)
        }
    }

    func updateValue(newValue: Bool) {
        print(airPodCheck)
        airPodCheck = newValue
    }
}

class WelcomeAirPodCheckModel {
    static let shared = WelcomeAirPodCheckModel()

    private init() {}

    @objc dynamic var welcomeAirPodCheck:Bool = false {
        didSet {
            // airPodChec의 값이 변경될 때마다 호출되는 코드
            // NotificationCenter를 이용하여 값을 알린다
            NotificationCenter.default.post(name: NSNotification.Name("welcomeAirpodcheck"), object: nil)
        }
    }

    func updateValue(newValue: Bool) {
        print(welcomeAirPodCheck)
        welcomeAirPodCheck = newValue
    }
}

class ZeroCheckModel {
    static let shared = ZeroCheckModel()
    
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
