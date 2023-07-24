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

class CustomHaptics {
    
    var engine: CHHapticEngine?
    
    init?() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return nil
        }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
            handleEngineStop()
            prepareResetEngine()
            print("여기는 init")
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
            return nil
        }
        print("여기는 init")
    }
    
    private func handleEngineStop() {
        // The engine stopped; print out why
        engine?.stoppedHandler = { reason in
            print("The engine stopped: \(reason)")
        }
    }
    
    private func prepareResetEngine() {
        // If something goes wrong, attempt to restart the engine immediately
        engine?.resetHandler = { [weak self] in
            print("The engine reset")
            do {
                try self?.engine?.start()
            } catch {
                print("Failed to restart the engine: \(error)")
            }
        }
    }
    
    func generateHaptic(intensity intensityValue: Float, sharpness sharpnessValue: Float) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }

        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensityValue)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpnessValue)

        let events = [
            CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0),
        ]
        
        print("여기는 generate")
        startEvents(events)
    }
    
    private func startEvents(_ events: [CHHapticEvent]) {
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    func turtlehaptic() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }
        
        var events = [CHHapticEvent]()
        
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [
                intensity,
                sharpness,
            ], relativeTime: i * 3)
            events.append(event)
        }
        print("여기는 터틀 햅틱")
        startEvents(events)
    }
    
    func hapticBeethoven5() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }
        
        let startIntensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.3)
        let startSharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
        
        let beat = 0.156
        let breath = 0.01
        let secondPassage = (beat * 4) + breath + (beat * 4 * 2.3) + (beat * 5.1)
        
        let events = [
            CHHapticEvent(eventType: .hapticTransient, parameters: [startIntensity, startSharpness], relativeTime: 0),
            CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: beat),
            CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: beat * 2),
            CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: beat * 3),
            
            CHHapticEvent(eventType: .hapticContinuous, parameters: [], relativeTime: beat * 4 + breath, duration: beat * 4 * 2.3),
            
            CHHapticEvent(eventType: .hapticTransient, parameters: [startIntensity, startSharpness], relativeTime: secondPassage),
            CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: secondPassage + beat),
            CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: secondPassage + beat * 2),
            CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: secondPassage + beat * 3),
            
            CHHapticEvent(eventType: .hapticContinuous, parameters: [], relativeTime: secondPassage + beat * 4 + breath, duration: beat * 4 * 2.3),
        ]
        
        startEvents(events)
    }
    
    //let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensityValue)
    //let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpnessValue)
    
}
