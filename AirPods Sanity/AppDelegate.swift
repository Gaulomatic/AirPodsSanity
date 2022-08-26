//
//  AppDelegate.swift
//  AirPods Sanity
//
//  Created by Tobias Punke on 26.08.22.
//

import Foundation
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject
{
    private var statusItem: NSStatusItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        //return
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button
        {
            button.title = "AirPods"
        }
        
        setupMenus()
    }
    
    func setupMenus() {
            // 1
            let menu = NSMenu()

            // 2
        //  let one = NSMenuItem(title: "One", action: #selector(didTapOne) , keyEquivalent: "1")
        //  menu.addItem(one)

        //  let two = NSMenuItem(title: "Two", action: #selector(didTapTwo) , keyEquivalent: "2")
        // menu.addItem(two)

        //let three = NSMenuItem(title: "Three", action: #selector(didTapThree) , keyEquivalent: "3")
        //menu.addItem(three)

            //menu.addItem(NSMenuItem.separator())

            menu.addItem(NSMenuItem(title: "Beenden", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

            // 3
            statusItem.menu = menu
        }
    
    private func changeStatusBarButton(number: Int) {
            if let button = statusItem.button {
                
                    button.title = "AirPods"
                //button.image = NSImage(systemSymbolName: "\(number).circle", accessibilityDescription: number.description)
            }
        }

        @objc func didTapOne() {
            changeStatusBarButton(number: 1)
        }

        @objc func didTapTwo() {
            changeStatusBarButton(number: 2)
        }

        @objc func didTapThree() {
            changeStatusBarButton(number: 3)
        }
}
