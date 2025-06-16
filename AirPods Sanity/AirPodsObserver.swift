//
//  ObservableSCA.swift
//  AirPods Sanity
//
//  Created by Tobias Punke on 25.08.22.
//

import Foundation
import SimplyCoreAudio

class AirPodsObserver: ObservableObject
{
	private let _Preferences: Preferences
	private let _Simply: SimplyCoreAudio
	private let _NotificationCenter: NotificationCenter

	private var _Observers: [NSObjectProtocol]

	private var _DefaultInputDeviceName: String?

	init()
	{
		self._Preferences = Preferences.Instance
		self._Simply = SimplyCoreAudio()
		self._NotificationCenter = NotificationCenter.default
		self._Observers = []

		self.UpdateDefaultInputDevice()
		self.AddObservers()
	}

	deinit
	{
		self.RemoveObservers()
	}
}

private extension AirPodsObserver
{
	func UpdateDefaultInputDevice()
	{
		guard let __DefaultInputDevice = self._Simply.defaultInputDevice else { return }
		guard let _ = self._Preferences.AirPodsDeviceNames.filter({ $0 == __DefaultInputDevice.name }).first else
		{
			self._DefaultInputDeviceName = __DefaultInputDevice.name
			return
		}

		if !self._Preferences.IsEnabled
		{
			return
		}

		guard let __NewInputDeviceName = self._Preferences.InputDeviceName != nil ? self._Preferences.InputDeviceName : self._DefaultInputDeviceName else { return }
		guard let __InputDevice = self._Simply.allInputDevices.filter({ $0.name == __NewInputDeviceName }).first else { return }

		if __DefaultInputDevice.id != __InputDevice.id
		{
			self.RemoveObservers()
			__InputDevice.isDefaultInputDevice = true
			self.AddObservers()
		}

		let __Seconds = 10.0

		DispatchQueue.main.asyncAfter(deadline: .now() + __Seconds)
		{
			guard let __DefaultOutputDevice = self._Simply.defaultOutputDevice else { return }
			guard let __SampleRates = __DefaultOutputDevice.nominalSampleRates?.sorted(by: { $0 > $1 }) else { return }

			self.RemoveObservers()
			__DefaultOutputDevice.setNominalSampleRate(__SampleRates[0])
			self.AddObservers()
		}
	}

	func AddObservers()
	{
		self._Observers.append(contentsOf:[
			self._NotificationCenter.addObserver(forName: .defaultInputDeviceChanged, object: nil, queue: .main) { (_) in
				self.UpdateDefaultInputDevice()
			},
		])
	}

	func RemoveObservers()
	{
		for __Observer in self._Observers
		{
			self._NotificationCenter.removeObserver(__Observer)
		}

		self._Observers.removeAll()
	}
}
