//
// Created by Tobias Punke on 27.08.22.
//

import Foundation

class Preferences
{
	private static var _Instance: Preferences?
	private let _PreferencesFile: PreferencesFile

	private init()
	{
		self._PreferencesFile = PreferencesLoader.LoadSettings()
	}
	
	static var Instance: Preferences
	{
		if _Instance == nil
		{
			_Instance = Preferences()
		}

		return _Instance!
	}
	
	public var LaunchOnLogin: Bool
	{
		get
		{
			if let __UnWrapped = self._PreferencesFile.LaunchOnLogin
			{
				return __UnWrapped
			}
			else
			{
				return false
			}
		}
		set(value)
		{
			self._PreferencesFile.LaunchOnLogin = value
		}
	}
	
	public var ShowInMenuBar: Bool
	{
		get
		{
			if let __UnWrapped = self._PreferencesFile.ShowInMenuBar
			{
				return __UnWrapped
			}
			else
			{
				return true
			}
		}
		set(value)
		{
			self._PreferencesFile.ShowInMenuBar = value
		}
	}
	
	public var ShowInDock: Bool
	{
		get
		{
			if let __UnWrapped = self._PreferencesFile.ShowInDock
			{
				return __UnWrapped
			}
			else
			{
				return false
			}
		}
		set(value)
		{
			self._PreferencesFile.ShowInDock = value
		}
	}
	
	public var IsEnabled: Bool
	{
		get
		{
			if let __UnWrapped = self._PreferencesFile.IsEnabled
			{
				return __UnWrapped
			}
			else
			{
				return true
			}
		}
		set(value)
		{
			self._PreferencesFile.IsEnabled = value
		}
	}
	
	public var InputDeviceName: String?
	{
		get
		{
			return self._PreferencesFile.InputDeviceName
		}
		set(value)
		{
			self._PreferencesFile.InputDeviceName = value
		}
	}
	
	public var AirPodsDeviceNames: [String]
	{
		get
		{
			if let __UnWrapped = self._PreferencesFile.AirPodsDeviceNames
			{
				return __UnWrapped
			}
			else
			{
				return []
			}
		}
		set(value)
		{
			self._PreferencesFile.AirPodsDeviceNames = value
		}
	}
	
	public func WriteSettings()
	{
		PreferencesLoader.WriteSettings(preferences: self._PreferencesFile)
	}
}
