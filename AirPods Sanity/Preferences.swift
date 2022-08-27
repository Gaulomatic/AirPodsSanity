//
// Created by Tobias Punke on 27.08.22.
//

import Foundation

class Preferences: Codable
{
	var ShowInDock: Bool
	var InputDeviceName: String?
	var AirPodsDeviceNames: [String]

	init()
	{
		self.ShowInDock = false
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
