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
    private let NotificationName = Notification.Name("eu.punke.AirPods-Sanity.AppLaunched")
    
    private let _Preferences: Preferences
    
	private var _Devices: DevicesObserver!
	private var _MenuBar: MenuBar!
	private var _Subscription: IDisposable!
    
    override init()
    {
        self._Preferences = Preferences.Instance
    }

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
    func applicationDidBecomeActive(_ notification: Notification)
    {
    }

	func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool
	{
        // https://stackoverflow.com/a/59003304/2239781
        let __AppleEvent: NSAppleEventDescriptor? = NSAppleEventManager.shared().currentAppleEvent
        let __SenderName: String = __AppleEvent?.attributeDescriptor(forKeyword: keyAddressAttr)?.stringValue ?? ""
//        let __SenderPID: Int32? = __AppleEvent?.attributeDescriptor(forKeyword: keySenderPIDAttr)?.int32Value ?? 0
        
        if __SenderName != "Dock"
        {
            self.PerformSecondLaunchActions()
        }
        else if !self._Preferences.ShowInDock
        {
            self.PerformSecondLaunchActions()
        }
        
		return false
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
        DistributedNotificationCenter.default().post(name: NotificationName, object: nil)
    }
    
    private func SetupLaunchNotificationListener()
    {
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(HandleSecondLaunch), name: NotificationName, object: nil)
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
        
        self._MenuBar.Show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
        {
            self._MenuBar.Show()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0)
        {
            self._MenuBar.Show()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0)
        {
            if !self._Preferences.ShowInMenuBar
            {
                self._MenuBar.Hide()
            }
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
