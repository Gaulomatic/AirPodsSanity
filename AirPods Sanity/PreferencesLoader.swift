//
// Created by Tobias Punke on 27.08.22.
//

import Foundation

class PreferencesLoader
{
	static private var PlistURL: URL
	{
		let __DocumentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		return __DocumentsPath.appendingPathComponent("settings.plist")
	}

	static func LoadSettings() -> PreferencesFile
	{
		let decoder = PropertyListDecoder()

		guard let __Data = try? Data.init(contentsOf: PlistURL),
			  let __Preferences = try? decoder.decode(PreferencesFile.self, from: __Data)
		else
		{
			return PreferencesFile()
		}

		return __Preferences
	}

	static func WriteSettings(preferences: PreferencesFile)
	{
		let __Encoder = PropertyListEncoder()

		if let __Data = try? __Encoder.encode(preferences)
		{
			if FileManager.default.fileExists(atPath: PlistURL.path)
			{
				// Update an existing plist
				try? __Data.write(to: PlistURL)
			}
			else
			{
				// Create a new plist
				FileManager.default.createFile(atPath: PlistURL.path, contents: __Data, attributes: nil)
			}
		}
	}
}
