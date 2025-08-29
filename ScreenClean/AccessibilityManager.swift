//
//  AccessibilityManager.swift
//  ScreenClean
//
//  Created by Noah Johann on 29.08.25.
//

import SwiftUI

class AccessibilityManager {
    static func getStatus() -> Bool {
        // Get current state for accessibility access
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: false]
        let status = AXIsProcessTrustedWithOptions(options)

        return status
    }

    @discardableResult
    static func requestAccess() -> Bool {
        if AccessibilityManager.getStatus() {
            return true
        }

        let alert = NSAlert()
        alert.messageText = .init("ScreenClean Needs Accessibility Permissions")
        alert.informativeText = .init("Please grant accessibility permissions to allow locking the keyboard.")
        alert.runModal()

        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
        let status = AXIsProcessTrustedWithOptions(options)

        return status
    }
}
