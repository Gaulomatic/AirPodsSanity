//
//  ObservableSCA.swift
//  AirPods Sanity
//
//  Created by Tobias Punke on 25.08.22.
//

import Foundation
import SimplyCoreAudio

class ObservableSCA: ObservableObject
{

    private let _Simply = SimplyCoreAudio()
    private var _Observers = [NSObjectProtocol]()
    private let _NotificationCenter = NotificationCenter.default

    init()
    {
        self.UpdateDefaultInputDevice()
        self.UpdateDefaultOutputDevice()
        self.UpdateDefaultSystemDevice()

        self.AddSCAObservers()
    }

    deinit
    {
        self.RemoveSCAObservers()
    }
}

private extension ObservableSCA
{
    func UpdateDefaultInputDevice()
    {
        if let __DefaultInputDevice = self._Simply.defaultInputDevice
        {
            let __AllInputDevices = self._Simply.allInputDevices
            let __YetiName = "Yeti Stereo Microphone"
            let __Yetis = __AllInputDevices.filter { $0.name == __YetiName }
            
            if __Yetis.isEmpty
            {
                return
            }
            
            let __Yeti = __Yetis[0]
            
            if __DefaultInputDevice.id != __Yeti.id
            {
                __Yeti.isDefaultInputDevice = true
            }
            
            let __AirPodsName = "Tobias' AirPods Pro"
            let __DefaultOutputDevice = self._Simply.defaultOutputDevice
            let __Seconds = 10.0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + __Seconds)
            {
                if __DefaultOutputDevice?.name != __AirPodsName
                {
                    return
                }
                
                __DefaultOutputDevice?.setNominalSampleRate(48000)
            }
            
        }
    }

    func UpdateDefaultOutputDevice()
    {
    }

    func UpdateDefaultSystemDevice()
    {
    }

    func AddSCAObservers()
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

    func RemoveSCAObservers()
    {
        for __Observer in self._Observers
        {
            self._NotificationCenter.removeObserver(__Observer)
        }

        self._Observers.removeAll()
    }
}
