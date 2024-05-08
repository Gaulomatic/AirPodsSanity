//
//  AppDelegate.swift
//  AirPods Sanity
//
//  Created by Tobias Punke on 26.08.22.
//

import AppKit
import Foundation
import SimplyCoreAudio

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject
{
    private let notificationName = Notification.Name("eu.punke.AirPods-Sanity.AppLaunched")
    
	private var _Devices: DevicesObserver!
	private var _MenuBar: MenuBar!
	private var _Subscription: IDisposable!

	func applicationDidFinishLaunching(_ notification: Notification)
	{
        if self.IsAlreadyRunning()
        {
            self.SendLaunchNotification()
            NSApp.terminate(nil)
        }
        else
        {
            SetupApplication()
        }
	}

	func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool
	{
		false
	}

	func applicationWillTerminate(_ notification: Notification)
	{
		if self._Subscription != nil
		{
			self._Subscription.dispose()
		}
	}
    
    private func IsAlreadyRunning() -> Bool
    {
        let __RunningApps = NSWorkspace.shared.runningApplications
        let __CurrentApp = Bundle.main.bundleIdentifier!
        
        return __RunningApps.filter { $0.bundleIdentifier == __CurrentApp }.count > 1
    }
    
    private func SendLaunchNotification()
    {
        DistributedNotificationCenter.default().post(name: notificationName, object: nil)
    }
    
    private func SetupLaunchNotificationListener()
    {
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(HandleSecondLaunch), name: notificationName, object: nil)
    }
    
    @objc private func HandleSecondLaunch()
    {
        self.PerformSecondLaunchActions()
    }
    
    private func PerformSecondLaunchActions()
    {
        if self._MenuBar.IsVisible
        {
            return
        }
        
        let __ShowInSeconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + __ShowInSeconds)
        {
            self._MenuBar.Show()
        }
        
        let __HideInSeconds = 10.0
        DispatchQueue.main.asyncAfter(deadline: .now() + __HideInSeconds)
        {
            self._MenuBar.HideWhenNeccessary()
        }
    }
    
    private func SetupApplication()
    {
        // Hide the window when the application finishes launching
        if let window = NSApplication.shared.windows.first
        {
            window.orderOut(self)
        }
        
        self._MenuBar = MenuBar()
        self._Devices = DevicesObserver()
        self._Subscription = self._Devices.InputDevicesChanged.addHandler(target: self, handler: AppDelegate.OnInputDevicesChanged)

        self._MenuBar.CreateMenu()
        
        self.SetupLaunchNotificationListener()
    }

	func OnInputDevicesChanged(data: [AudioDevice])
	{
        let __IsMenuVisible = self._MenuBar.IsVisible
		self._MenuBar.CreateMenu()
        
        if __IsMenuVisible
        {
            self._MenuBar.Show()
        }
	}
}
