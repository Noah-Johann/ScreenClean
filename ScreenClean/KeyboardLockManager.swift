//
//  KeyboardLockManager.swift
//  ScreenClean
//
//  Created by Noah Johann on 14.06.25.
//

import Cocoa
import Carbon

class KeyboardLockManager: ObservableObject {
    @Published var isKeyboardLocked = false
    @Published var permissionEnabled: Bool = false
    private var eventTap: CFMachPort?
    
    init() {
        permissionEnabled = requestAccessibilityPermissions()
    }
    
    func requestAccessibilityPermissions() -> Bool {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options as CFDictionary)
        
        if accessEnabled {
            return true
        }
        
        if !accessEnabled {
            print("Accessibility permissions required for keyboard locking")
            return false

        }
        
        return false
    }
    
    func toggleKeyboardLock() {
        isKeyboardLocked.toggle()
        
        if isKeyboardLocked {
            startKeyboardLock()
        } else {
            stopKeyboardLock()
        }
        
        print("Keyboard \(isKeyboardLocked ? "locked" : "unlocked")")
    }
    
    private func startKeyboardLock() {
        guard AXIsProcessTrusted() else {
            print("No accessibility permissions - cannot lock keyboard")
            isKeyboardLocked = false
            return
        }
        
        let keyboardEvents = (1 << CGEventType.keyDown.rawValue) |
                            (1 << CGEventType.keyUp.rawValue) |
                            (1 << CGEventType.flagsChanged.rawValue)
        
        let mouseEvents = (1 << CGEventType.otherMouseDown.rawValue) |
                         (1 << CGEventType.otherMouseUp.rawValue) |
                         (1 << CGEventType.otherMouseDragged.rawValue)
        
        let otherEvents = (1 << CGEventType.scrollWheel.rawValue) |
                         (1 << CGEventType.tabletPointer.rawValue) |
                         (1 << CGEventType.tabletProximity.rawValue)
        
        let systemEvents = (1 << 14) // NX_SYSDEFINED
        
        let eventMask = CGEventMask(keyboardEvents | mouseEvents | otherEvents | systemEvents)
        
        eventTap = CGEvent.tapCreate(
            tap: .cghidEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: eventMask,
            callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
                let manager = Unmanaged<KeyboardLockManager>.fromOpaque(refcon!).takeUnretainedValue()
                
                if manager.isKeyboardLocked {
                    switch type.rawValue {
                    case CGEventType.keyDown.rawValue, CGEventType.keyUp.rawValue:
                        let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
                        print("Keyboard event blocked (key code: \(keyCode))")
                        
                    case CGEventType.flagsChanged.rawValue:
                        print("Modifier key event blocked")
                    case 14: // NX_SYSDEFINED
                        let subType = event.getIntegerValueField(.eventSourceUserData)
                        let keyCode = (subType & 0xFFFF0000) >> 16
                        let keyFlags = subType & 0x0000FFFF
                        let keyDown = (keyFlags & 0x0100) != 0
                        
                        print("System event blocked - KeyCode: \(keyCode), KeyDown: \(keyDown)")
                        
                    default:
                        print("Other event blocked - Type: \(type.rawValue)")
                    }
                    
                    return nil
                }
                
                return Unmanaged.passUnretained(event)
            },
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        )
        
        if let eventTap = eventTap {
            let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
            CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
            CGEvent.tapEnable(tap: eventTap, enable: true)
            isKeyboardLocked = true
        } else {
            isKeyboardLocked = false
        }
    }

    private func stopKeyboardLock() {
        if let eventTap = eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: false)
            CFMachPortInvalidate(eventTap)
            self.eventTap = nil
        }
        isKeyboardLocked = false
        print("Keyboard unlocked")
    }
    
    func cleanup() {
        stopKeyboardLock()
    }
    
    deinit {
        cleanup()
    }
}
