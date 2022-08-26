//
//  AirPods_SanityApp.swift
//  AirPods Sanity
//
//  Created by Tobias Punke on 25.08.22.
//
//  https://sarunw.com/posts/swiftui-menu-bar-app/
//  https://sarunw.com/posts/how-to-make-macos-menu-bar-app/
//  https://github.com/rnine/SimplyCoreAudio
//  

import SwiftUI

@main
struct AirPods_SanityApp: App
{
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var _AppDelegate
    
    @StateObject private var sca = ObservableSCA()
    @State var currentNumber: String = "1"
    
    var body: some Scene
    {
        WindowGroup
        {
            ContentView()
                .environmentObject(sca)
        }
        .commands
        {
            CommandMenu("My Top Menu")
            {
                Button("Sub Menu Item") { print("You pressed sub menu.") }
                  .keyboardShortcut("S")
            }
            CommandGroup(replacing: .pasteboard)
            {
                Button("Cut") { print("Cutting something...") }
                  .keyboardShortcut("X")
                Button("Copy") { print("Copying something...") }
                  .keyboardShortcut("C")
                Button("Paste") { print("Pasting something...") }
                  .keyboardShortcut("V")
                Button("Paste and Match Style") { print("Pasting and Matching something...") }
                  .keyboardShortcut("V", modifiers: [.command, .option, .shift])
                Button("Delete") { print("Deleting something...") }
                  .keyboardShortcut(.delete)
                Button("Select All") { print("Selecting something...") }
                  .keyboardShortcut("A")
              
            }
        }
    }
}
