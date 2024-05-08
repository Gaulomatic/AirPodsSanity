//
// Created by Tobias Punke on 27.08.22.
//

import Foundation

class Preferences: Codable
{
	var LaunchOnLogin: Bool
	var ShowInMenuBar: Bool
	var ShowInDock: Bool
	var IsEnabled: Bool
	var InputDeviceName: String?
	var AirPodsDeviceNames: [String]

	init()
	{
		self.LaunchOnLogin = false
		self.ShowInMenuBar = true
		self.ShowInDock = false
		self.IsEnabled = true
		self.AirPodsDeviceNames = []
	}

	static private var _Instance: Preferences?

	static var Instance: Preferences
	{
		if _Instance == nil
		{
			_Instance = PreferencesLoader.LoadSettings()
		}

		return _Instance!
	}
}
