//
//  ScreenCleanApp.swift
//  ScreenClean
//
//  Created by Noah Johann on 13.06.25.
//

import SwiftUI

@main
struct ScreenCleanApp: App {
    var body: some Scene {
        WindowGroup {
            EmptyView()
        }.commands {
            CommandGroup(replacing: .appInfo) {}
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }

    init() {
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
    }
}
