//
//  Storage.swift
//  DdokBaro
//
//  Created by 신서연 on 2023/07/30.
//

import UIKit
public class Storage {
    static func isFirstTime() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "isFirstTime") == nil {
            defaults.set("No", forKey:"isFirstTime")
            return true
        } else {
            return false
        }
    }
}
