//
//  CleaningView.swift
//  ScreenClean
//
//  Created by Noah Johann on 13.06.25.
//

import SwiftUI

struct CleaningView: View {
    let keyboardManager = KeyboardLockManager()
    @State var isKeyboard: Bool = false

    var body: some View {
        ZStack {
            Color.black.opacity(1).edgesIgnoringSafeArea(.all)
            
            Spacer()
            
            VStack {
                Spacer()
                
                Button(action: {
                    keyboardManager.toggleKeyboardLock()
                    isKeyboard = keyboardManager.isKeyboardLocked
                }, label: {
                    if #available(macOS 13.0, *) {
                        Image(systemName: isKeyboard == false ? "lock.open.display" : "lock.display")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .fontWeight(.light)
                            .frame(width: 200, height: 200)
                    } else {
                        Image(systemName: isKeyboard == false ? "lock.open.display" : "lock.display")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)                    }
                })
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                Button(action: {
                    keyboardManager.cleanup()
                    NSApp.terminate(nil)
                }, label: {
                    if #available(macOS 13.0, *) {
                        Image(systemName: "x.circle")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 80, height: 80)
                            .fontWeight(.light)
                    } else {
                        Image(systemName: "x.circle")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 80, height: 80)                    }
                })
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, 40)
            }
        } 
    }
}

#Preview {
    CleaningView()
}
