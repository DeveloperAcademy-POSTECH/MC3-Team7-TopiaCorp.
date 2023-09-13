//
//  Haptics.swift
//  DdokBaro
//
//  Created by yusang on 2023/07/22.
//

import Foundation
import UIKit
import CoreHaptics
import Combine

class HapticManager {
    
    let hapticEngine: CHHapticEngine
    
    init?() {
      
      let hapticCapability = CHHapticEngine.capabilitiesForHardware()
      guard hapticCapability.supportsHaptics else {
        return nil
      }

      do {
        hapticEngine = try CHHapticEngine()
      } catch let error {
        print("Haptic engine Creation Error: \(error)")
        return nil
      }
    }
    
    func playPattern() {
        do {
          let pattern = try continuousVibration()
          try hapticEngine.start()
          let player = try hapticEngine.makePlayer(with: pattern)
          try player.start(atTime: CHHapticTimeImmediate)
          hapticEngine.notifyWhenPlayersFinished { _ in
            return .stopEngine
          }
        } catch {
          print("Failed to play pattern: \(error)")
        }
      }
}

extension HapticManager {
  private func basicPattern() throws -> CHHapticPattern {

        let pattern = CHHapticEvent(
          eventType: .hapticTransient,
          parameters: [
            CHHapticEventParameter(parameterID: .hapticIntensity, value: 3.0),
            CHHapticEventParameter(parameterID: .hapticSharpness, value: 3.0)
          ],
          relativeTime: 1)

        return try CHHapticPattern(events: [pattern], parameters: [])
  }
    
    private func continuousVibration() throws -> CHHapticPattern {
        let duration = 1000
        let hapticIntensity: Float
        hapticIntensity = 1.0
        let continuousVibrationEvent = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: hapticIntensity)
            ],
            relativeTime: 0,
            duration: (Double(duration)/1000))
        return try CHHapticPattern(events: [continuousVibrationEvent], parameters: [])
    }
}
