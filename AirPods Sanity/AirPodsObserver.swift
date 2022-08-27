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
	private let _Preferences = Preferences.Instance
	private let _Simply = SimplyCoreAudio()
	private let _NotificationCenter = NotificationCenter.default

	private var _Observers = [NSObjectProtocol]()

	init()
	{
		self.UpdateDefaultInputDevice()
		self.UpdateDefaultOutputDevice()
		self.UpdateDefaultSystemDevice()

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
		if let __DefaultInputDevice = self._Simply.defaultInputDevice
		{
			var __DefaultOutputDevice = self._Simply.defaultOutputDevice

			if __DefaultOutputDevice == nil
			{
				return
			}

			let __OutputDevices = self._Preferences.AirPodsDeviceNames.filter { $0 == __DefaultOutputDevice?.name }

			if __OutputDevices.isEmpty
			{
				return
			}

			let __AllInputDevices = self._Simply.allInputDevices
			let __InputDeviceName = self._Preferences.InputDeviceName
			let __InputDevices = __AllInputDevices.filter { $0.name == __InputDeviceName }

			if __InputDevices.isEmpty
			{
				return
			}

			let __InputDevice = __InputDevices[0]

			if __DefaultInputDevice.id != __InputDevice.id
			{
				__InputDevice.isDefaultInputDevice = true
			}

			let __Seconds = 10.0

			DispatchQueue.main.asyncAfter(deadline: .now() + __Seconds)
			{
				__DefaultOutputDevice = self._Simply.defaultOutputDevice

				let __SampleRates = __DefaultOutputDevice?.nominalSampleRates?.sorted(by: { $0 > $1 })

				if __SampleRates == nil
				{
					return
				}

				if __SampleRates!.isEmpty
				{
					return
				}

				__DefaultOutputDevice?.setNominalSampleRate(__SampleRates![0])
			}
		}
	}

	func UpdateDefaultOutputDevice()
	{
	}

	func UpdateDefaultSystemDevice()
	{
	}

	func AddObservers()
	{
		self._Observers.append(contentsOf: [
			self._NotificationCenter.addObserver(forName: .deviceListChanged, object: nil, queue: .main) { (notification) in
			},

			self._NotificationCenter.addObserver(forName: .defaultInputDeviceChanged, object: nil, queue: .main) { (_) in
				self.UpdateDefaultInputDevice()
			},

			self._NotificationCenter.addObserver(forName: .defaultOutputDeviceChanged, object: nil, queue: .main) { (_) in
				self.UpdateDefaultOutputDevice()
			},

			self._NotificationCenter.addObserver(forName: .defaultSystemOutputDeviceChanged, object: nil, queue: .main) { (_) in
				self.UpdateDefaultSystemDevice()
			},

			self._NotificationCenter.addObserver(forName: .deviceNominalSampleRateDidChange, object: nil, queue: .main) { (notification) in
			},

			self._NotificationCenter.addObserver(forName: .deviceClockSourceDidChange, object: nil, queue: .main) { (notification) in
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
