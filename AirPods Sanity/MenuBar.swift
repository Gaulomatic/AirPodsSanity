//
// Created by Tobias Punke on 27.08.22.
//

import AppKit
import Foundation
import SimplyCoreAudio

class MenuBar
{
	private let _SimplyCoreAudio: SimplyCoreAudio
	private let _Preferences: Preferences

	private var _InputDeviceItems: [NSMenuItem]
	private var _OutputDeviceItems: [NSMenuItem]

	private let _StatusBarItem: NSStatusItem

	init()
	{
		self._SimplyCoreAudio = SimplyCoreAudio()
		self._Preferences = Preferences.Instance

		self._StatusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

		self._InputDeviceItems = []
		self._OutputDeviceItems = []

		if let __Button = self._StatusBarItem.button
		{
			__Button.title = "AirPods"
		}

		self.ToggleShowInDock()
	}

	func CreateMenu()
	{
		self._InputDeviceItems.removeAll()
		self._InputDeviceItems = self.CreateInputDeviceItems(simply: self._SimplyCoreAudio, preferences: self._Preferences)

		self._OutputDeviceItems.removeAll()
		self._OutputDeviceItems = self.CreateOutputDeviceItems(simply: self._SimplyCoreAudio, preferences: self._Preferences)

		let __Menu = NSMenu()

		__Menu.addItem(self.CreateShowInDockItem(preferences: self._Preferences))

		__Menu.addItem(NSMenuItem.separator())
		self.AddItems(menu: __Menu, items: self._InputDeviceItems, label: "Input Devices:")

		__Menu.addItem(NSMenuItem.separator())
		self.AddItems(menu: __Menu, items: self._OutputDeviceItems, label: "AirPod Devices:")

		__Menu.addItem(NSMenuItem.separator())
		__Menu.addItem(self.CreateQuitApplicationItem())

		self._StatusBarItem.menu = __Menu
	}

	private func CreateShowInDockItem(preferences: Preferences) -> NSMenuItem
	{
		let __MenuItem = NSMenuItem()

		__MenuItem.title = "Show in Dock"
		__MenuItem.target = self
		__MenuItem.action = #selector(OnToggleShowInDock(_:))

		if preferences.ShowInDock
		{
			__MenuItem.state = NSControl.StateValue.on
		}
		else
		{
			__MenuItem.state = NSControl.StateValue.off
		}

		return __MenuItem
	}

	private func CreateQuitApplicationItem() -> NSMenuItem
	{
		return NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
	}

	private func CreateInputDeviceItems(simply: SimplyCoreAudio, preferences: Preferences) -> [NSMenuItem]
	{
		let __InputDevices = simply.allInputDevices
		var __MenuItems: [NSMenuItem] = []

		for __AudioDevice in __InputDevices
		{
			let __MenuItem = NSMenuItem()

			__MenuItem.title = __AudioDevice.name
			__MenuItem.target = self
			__MenuItem.action = #selector(OnSelectInputDevice(_:))
			__MenuItem.state = NSControl.StateValue.off

			if __AudioDevice.name == preferences.InputDeviceName
			{
				__MenuItem.state = NSControl.StateValue.on
			}

			__MenuItems.append(__MenuItem)
		}

		return __MenuItems.sorted(by: { $0.title < $1.title })
	}

	private func CreateOutputDeviceItems(simply: SimplyCoreAudio, preferences: Preferences) -> [NSMenuItem]
	{
		let __InputDevices = simply.allOutputDevices
		var __MenuItems: [NSMenuItem] = []

		for __AudioDevice in __InputDevices
		{
			let __MenuItem = NSMenuItem()

			__MenuItem.title = __AudioDevice.name
			__MenuItem.target = self
			__MenuItem.action = #selector(OnSelectOutputDevice(_:))
			__MenuItem.state = NSControl.StateValue.off

			if preferences.AirPodsDeviceNames.contains(__AudioDevice.name)
			{
				__MenuItem.state = NSControl.StateValue.on
			}

			__MenuItems.append(__MenuItem)
		}

		return __MenuItems.sorted(by: { $0.title < $1.title })
	}

	private func AddItems(menu: NSMenu, items: [NSMenuItem], label: String)
	{
		let __Label = NSMenuItem()

		__Label.title = label
		__Label.isEnabled = false

		menu.addItem(__Label)

		for __MenuItem in items
		{
			menu.addItem(__MenuItem)
		}
	}

	private func ToggleShowInDock()
	{
		let __Preferences = self._Preferences

		if __Preferences.ShowInDock
		{
			// The application is an ordinary app that appears in the Dock and may
			// have a user interface.
			NSApp.setActivationPolicy(.regular)
		}
		else
		{
			// The application does not appear in the Dock and may not create
			// windows or be activated.
			NSApp.setActivationPolicy(.prohibited)
		}
	}

	@objc private func OnToggleShowInDock(_ sender: NSMenuItem)
	{
		let __Preferences = self._Preferences
		let __State = sender.state

		if __State == NSControl.StateValue.on
		{
			__Preferences.ShowInDock = false
			sender.state = NSControl.StateValue.off
		}
		else if __State == NSControl.StateValue.off
		{
			__Preferences.ShowInDock = true
			sender.state = NSControl.StateValue.on
		}

		self.ToggleShowInDock()

		PreferencesLoader.WriteSettings(preferences: __Preferences)
	}

	@objc private func OnSelectInputDevice(_ sender: NSMenuItem)
	{
		let __Preferences = self._Preferences
		let __State = sender.state

		for __Item in self._InputDeviceItems
		{
			__Item.state = NSControl.StateValue.off
		}

		if __State == NSControl.StateValue.on
		{
			__Preferences.InputDeviceName = nil
		}
		else if __State == NSControl.StateValue.off
		{
			__Preferences.InputDeviceName = sender.title
			sender.state = NSControl.StateValue.on
		}

		PreferencesLoader.WriteSettings(preferences: __Preferences)
	}

	@objc private func OnSelectOutputDevice(_ sender: NSMenuItem)
	{
		let __Preferences = self._Preferences

		if sender.state == NSControl.StateValue.on
		{
			if __Preferences.AirPodsDeviceNames.contains(sender.title)
			{
				__Preferences.AirPodsDeviceNames = __Preferences.AirPodsDeviceNames.filter { $0 != sender.title }
			}

			sender.state = NSControl.StateValue.off
		}
		else if sender.state == NSControl.StateValue.off
		{
			if !__Preferences.AirPodsDeviceNames.contains(sender.title)
			{
				__Preferences.AirPodsDeviceNames.append(sender.title)
			}

			sender.state = NSControl.StateValue.on
		}

		PreferencesLoader.WriteSettings(preferences: __Preferences)
	}
}
