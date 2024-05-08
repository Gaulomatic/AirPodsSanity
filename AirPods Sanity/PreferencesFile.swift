//
//  PreferencesFile.swift
//  AirPods Sanity
//
//  Created by Tobias Punke on 08.05.24.
//  Copyright © 2024 Tobias Punke. All rights reserved.
//

import Foundation

class PreferencesFile: Codable
{
	var LaunchOnLogin: Bool?
	var ShowInMenuBar: Bool?
	var ShowInDock: Bool?
	var IsEnabled: Bool?
	var InputDeviceName: String?
	var AirPodsDeviceNames: [String]?
}
