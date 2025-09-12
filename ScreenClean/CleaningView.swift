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
    @AppStorage("isStartAuto") private var isStartAuto: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(1).edgesIgnoringSafeArea(.all)
            
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
                            .frame(width: 200, height: 200)
                    }
                })
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                ZStack {
                    if #available(macOS 26.0, *) {
                        Button(action: {
                            NSApp.terminate(nil)
                        }, label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .fontWeight(.light)
                                .padding(30)
                                .glassEffect()
                            
                        })
                        .buttonStyle(PlainButtonStyle())
                        .padding(.bottom, 40)
                        .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        Button(action: {
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
                                    .frame(width: 80, height: 80)
                            }
                        })
                        .buttonStyle(PlainButtonStyle())
                        .padding(.bottom, 40)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    HStack {
                        Button(action: {
                            isStartAuto.toggle()
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(Color.white.opacity(0.1))
                                    .frame(width: 80, height: 40)
                                Text("AUTO")
                                    .foregroundStyle(isStartAuto ? Color.white : Color.gray)
                                
                            }
                        }) .buttonStyle(PlainButtonStyle())
                        
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            }
        }
        .onAppear {
            isKeyboard = keyboardManager.isKeyboardLocked
        }
    }
}

#Preview {
    CleaningView()
}
