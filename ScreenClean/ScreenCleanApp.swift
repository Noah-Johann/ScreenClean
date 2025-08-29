//
//  ScreenCleanApp.swift
//  ScreenClean
//
//  Created by Noah Johann on 13.06.25.
//

import SwiftUI
import ApplicationServices
import Carbon
import Cocoa

@main
struct ScreenCleanApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        MenuBarExtra("ScreenClean") {
            Button("Quit", role: .destructive) {
                NSApp.terminate(nil)
            } .keyboardShortcut("Q", modifiers: .command)
        }
        .commands {
            CommandGroup(replacing: .appInfo) { }
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        let status = AccessibilityManager.getStatus()
        
        if status {
            DispatchQueue.main.async {
                if let screen = NSScreen.main {
                    let window = NSWindow(
                        contentRect: screen.frame,
                        styleMask: [.borderless],
                        backing: .buffered,
                        defer: false
                    )

                    window.level = .screenSaver
                    window.isOpaque = true
                    window.backgroundColor = .clear
                    window.contentView = NSHostingView(rootView: CleaningView())
                    window.makeKeyAndOrderFront(nil)
                    window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
                    NSApp.activate(ignoringOtherApps: true)
                }
            }
        } else {
            AccessibilityManager.requestAccess()

        }
        

    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        return true
    }

    func promptForAccessibilityPermission() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        _ = AXIsProcessTrustedWithOptions(options as CFDictionary)
    }
}
