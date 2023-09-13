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
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Notification 권한 성공")
            } else {
                print("Notification 권한 거부당함")
            }
        }
        
    }
    
    func scheduleNotification() {
        //content - 알림에 필요한 메세지의 기본속성을 설정하는 역할
        let content = UNMutableNotificationContent()
        content.title = "주토피아에서 알려드립니다" // 알림 제목 설정
        content.body = "거북목입니다" // 알림 내용 설정
        content.sound = UNNotificationSound.default
        
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
    
    func scheduleNotification50() {
        //content - 알림에 필요한 메세지의 기본속성을 설정하는 역할
        let content = UNMutableNotificationContent()
        content.title = "잠시 스트레칭을 해 볼까요?" // 알림 제목 설정
        content.body = "물이 50L 남았어요 \n 목을 가볍게 돌리고 기지개를 켜봐요" // 알림 내용 설정
        content.sound = UNNotificationSound.default
        
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
    func scheduleNotification20() {
        
        //content - 알림에 필요한 메세지의 기본속성을 설정하는 역할
        let content = UNMutableNotificationContent()
        content.title = "나쁜 자세가 지속되고 있어요" // 알림 제목 설정
        content.body = "물이 20L 남았어요 \n 잠시 스트레칭을 하고 자세를 바르게 해 볼까요?" // 알림 내용 설정
        content.sound = UNNotificationSound.default
        
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
    func scheduleNotification10() {
        //content - 알림에 필요한 메세지의 기본속성을 설정하는 역할
        let content = UNMutableNotificationContent()
        content.title = "물을 거의 다 쏟았어요" // 알림 제목 설정
        content.body = "물이 10L 남았어요 \n 다시 자세를 바르게 해 볼까요? 포기하지 말아요!" // 알림 내용 설정
        content.sound = UNNotificationSound.default
        
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
    func scheduleNotification0() {
        
        //content - 알림에 필요한 메세지의 기본속성을 설정하는 역할
        let content = UNMutableNotificationContent()
        content.title = "물이 다 쏟아졌어요" // 알림 제목 설정
        content.body = "남은 물이 없어요 \n 바른 자세를 학습하고 물을 다시 채워주세요" // 알림 내용 설정
        content.sound = UNNotificationSound.default
        
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
