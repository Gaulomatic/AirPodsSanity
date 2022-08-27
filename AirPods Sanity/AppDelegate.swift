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
	private var _Devices: DevicesObserver!
	private var _MenuBar: MenuBar!
	private var _Subscription: IDisposable!

	func applicationDidFinishLaunching(_ notification: Notification)
	{
		self._MenuBar = MenuBar()
		self._Devices = DevicesObserver()
		self._Subscription = self._Devices.InputDevicesChanged.addHandler(target: self, handler: AppDelegate.OnInputDevicesChanged)

		self._MenuBar.CreateMenu()
	}

	func applicationWillTerminate(_ notification: Notification)
	{
		if self._Subscription != nil
		{
			self._Subscription.dispose()
		}
	}

	func OnInputDevicesChanged(data: [AudioDevice])
	{
		self._MenuBar.CreateMenu()
	}
}
