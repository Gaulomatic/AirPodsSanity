//
// Created by Tobias Punke on 27.08.22.
//

import AppKit
import Foundation
import LaunchAtLogin
import SimplyCoreAudio

class MenuBar
{
	private let _SimplyCoreAudio: SimplyCoreAudio
	private let _Preferences: Preferences

	private var _InputDeviceItems: [NSMenuItem]
	private var _OutputDeviceItems: [NSMenuItem]

	private var _StatusBarItem: NSStatusItem

	init()
	{
		self._SimplyCoreAudio = SimplyCoreAudio()
		self._Preferences = Preferences.Instance

		self._InputDeviceItems = []
		self._OutputDeviceItems = []

		self._StatusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

		self.CreateStatusItem()
		self.SetShowInMenuBar()
		self.SetShowInDock()
	}

	private func CreateStatusItem()
	{
		let __Image = NSImage(named: "airpods-icon")

		__Image?.isTemplate = true

		if let __Button = self._StatusBarItem.button
		{
			__Button.toolTip = NSLocalizedString("MenuBar.ToolTip", comment: "")

			if __Image != nil
			{
				__Button.image = __Image
			}
			else
			{
				__Button.title = NSLocalizedString("MenuBar.ToolTip", comment: "")
			}
		}
	}

	public func CreateMenu()
	{
		self._InputDeviceItems.removeAll()
		self._InputDeviceItems = self.CreateInputDeviceItems(simply: self._SimplyCoreAudio, preferences: self._Preferences)

		self._OutputDeviceItems.removeAll()
		self._OutputDeviceItems = self.CreateOutputDeviceItems(simply: self._SimplyCoreAudio, preferences: self._Preferences)

		let __Menu = NSMenu()

		__Menu.addItem(self.CreateIsEnabledItem(preferences: self._Preferences))

		__Menu.addItem(NSMenuItem.separator())
		__Menu.addItem(self.CreateLaunchOnLoginItem(preferences: self._Preferences))
		__Menu.addItem(self.CreateShowInMenuBarItem(preferences: self._Preferences))
		__Menu.addItem(self.CreateShowInDockItem(preferences: self._Preferences))

		__Menu.addItem(NSMenuItem.separator())
		self.AddItems(menu: __Menu, items: self._InputDeviceItems, label: NSLocalizedString("MenuBar.InputDevices", comment: ""))

		__Menu.addItem(NSMenuItem.separator())
		self.AddItems(menu: __Menu, items: self._OutputDeviceItems, label: NSLocalizedString("MenuBar.OutputDevices", comment: ""))

		__Menu.addItem(NSMenuItem.separator())
		__Menu.addItem(self.CreateQuitApplicationItem())
		
		self.SetShowInMenuBar()
		self._StatusBarItem.menu = __Menu
	}
	
	public var IsVisible: Bool
	{
		get
		{
			return self._StatusBarItem.isVisible
		}
	}
	
	public func Show()
	{
		self._StatusBarItem.isVisible = true;
	}
	
	public func Hide()
	{
		self._StatusBarItem.isVisible = false;
	}
	
	private func SetShowInMenuBar()
	{
		self._StatusBarItem.isVisible = self._Preferences.ShowInMenuBar
	}
	
	private func SetLaunchOnLogin()
	{
		LaunchAtLogin.isEnabled = self._Preferences.LaunchOnLogin
	}
	
	private func SetShowInDock()
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
	
	private func CreateLaunchOnLoginItem(preferences: Preferences) -> NSMenuItem
	{
		let __MenuItem = NSMenuItem()

		__MenuItem.title = NSLocalizedString("MenuBar.LaunchOnLogin", comment: "")
		__MenuItem.target = self
		__MenuItem.action = #selector(OnToggleLaunchOnLogin(_:))

		if preferences.LaunchOnLogin
		{
			__MenuItem.state = NSControl.StateValue.on
		}
		else
		{
			__MenuItem.state = NSControl.StateValue.off
		}

		return __MenuItem
	}
	
	private func CreateShowInMenuBarItem(preferences: Preferences) -> NSMenuItem
	{
		let __MenuItem = NSMenuItem()

		__MenuItem.title = NSLocalizedString("MenuBar.ShowInMenuBar", comment: "")
		__MenuItem.target = self
		__MenuItem.action = #selector(OnToggleShowInMenuBar(_:))

		if preferences.ShowInMenuBar
		{
			__MenuItem.state = NSControl.StateValue.on
		}
		else
		{
			__MenuItem.state = NSControl.StateValue.off
		}

		return __MenuItem
	}

	private func CreateShowInDockItem(preferences: Preferences) -> NSMenuItem
	{
		let __MenuItem = NSMenuItem()

		__MenuItem.title = NSLocalizedString("MenuBar.ShowInDock", comment: "")
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

	private func CreateIsEnabledItem(preferences: Preferences) -> NSMenuItem
	{
		let __MenuItem = NSMenuItem()

		__MenuItem.title = NSLocalizedString("MenuBar.IsEnabled", comment: "")
		__MenuItem.target = self
		__MenuItem.action = #selector(OnToggleIsEnabled(_:))

		if preferences.IsEnabled
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
		let __QuitLabel = NSLocalizedString("MenuBar.Quit", comment: "")
		let __QuitShortcut = NSLocalizedString("MenuBar.QuitShortcut", comment: "")

		return NSMenuItem(title: __QuitLabel, action: #selector(NSApplication.terminate(_:)), keyEquivalent: __QuitShortcut)
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
	
	@objc private func OnToggleLaunchOnLogin(_ sender: NSMenuItem)
	{
		let __Preferences = self._Preferences
		let __State = sender.state

		if __State == NSControl.StateValue.on
		{
			__Preferences.LaunchOnLogin = false
			sender.state = NSControl.StateValue.off
		}
		else if __State == NSControl.StateValue.off
		{
			__Preferences.LaunchOnLogin = true
			sender.state = NSControl.StateValue.on
		}

		self.SetLaunchOnLogin()

		self._Preferences.WriteSettings()
	}
	
	@objc private func OnToggleShowInMenuBar(_ sender: NSMenuItem)
	{
		let __Preferences = self._Preferences
		let __State = sender.state

		if __State == NSControl.StateValue.on
		{
			__Preferences.ShowInMenuBar = false
			sender.state = NSControl.StateValue.off
		}
		else if __State == NSControl.StateValue.off
		{
			__Preferences.ShowInMenuBar = true
			sender.state = NSControl.StateValue.on
		}

		self.SetShowInMenuBar()
		
		self._Preferences.WriteSettings()
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

		self.SetShowInDock()
		
		self._Preferences.WriteSettings()
	}

	@objc private func OnToggleIsEnabled(_ sender: NSMenuItem)
	{
		let __Preferences = self._Preferences
		let __State = sender.state

		if __State == NSControl.StateValue.on
		{
			__Preferences.IsEnabled = false
			sender.state = NSControl.StateValue.off
		}
		else if __State == NSControl.StateValue.off
		{
			__Preferences.IsEnabled = true
			sender.state = NSControl.StateValue.on
		}
		
		self._Preferences.WriteSettings()
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
		
		self._Preferences.WriteSettings()
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
		
		self._Preferences.WriteSettings()
	}
}
