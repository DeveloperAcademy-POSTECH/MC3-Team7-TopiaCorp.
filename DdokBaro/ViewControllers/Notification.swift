//
//  Notification.swift
//  DdokBaro
//
//  Created by yusang on 2023/07/16.
//

import UserNotifications
import Foundation

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    let notificationCenter = UNUserNotificationCenter.current()
    static let shared = NotificationManager()
    
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification 권한 성공")
            } else {
                print("Notification 권한 거부당함")
            }
        }
        
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//            print("foreground 알람 작동 확인")
//            completionHandler([.alert, .badge, .sound])
//    }
    
    func scheduleNotification() {
        
        //content - 알림에 필요한 메세지의 기본속성을 설정하는 역할
        let content = UNMutableNotificationContent()
        content.title = "주토피아에서 알려드립니다" // 알림 제목 설정
        content.body = "거북목입니다" // 알림 내용 설정
        content.sound = UNNotificationSound.default
        content.badge = 1
     
        // trigger - time 발동 조건 관리 timeInterval은 초단위
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        
        //request - 알림 요청 생성
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        
        //알림 등록
        UNUserNotificationCenter.current().add(request)
        
        
    }
    
    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { settings in
            print("Notification settings: \(settings)")
        }
    }
}

//extension AppDelegate : UNUserNotificationCenterDelegate {
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.list,.sound,.banner])
//    }
//}
