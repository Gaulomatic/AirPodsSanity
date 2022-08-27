//
//  ObservableSCA.swift
//  AirPods Sanity
//
//  Created by Tobias Punke on 25.08.22.
//

import Foundation
import SimplyCoreAudio

class DevicesObserver: ObservableObject
{
	let InputDevicesChanged = Event<[AudioDevice]>()

	private let _Simply = SimplyCoreAudio()
	private var _Observers = [NSObjectProtocol]()
	private let _NotificationCenter = NotificationCenter.default

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

internal extension DevicesObserver
{
	func UpdateDefaultInputDevice()
	{
	}

	func UpdateDefaultOutputDevice()
	{
	}

	func UpdateDefaultSystemDevice()
	{
	}

	private func OnDeviceListChanged()
	{
		self.InputDevicesChanged.raise(data: self._Simply.allInputDevices)
	}

	func AddObservers()
	{
		self._Observers.append(contentsOf: [
			self._NotificationCenter.addObserver(forName: .deviceListChanged, object: nil, queue: .main) { (notification) in
				self.OnDeviceListChanged()
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
