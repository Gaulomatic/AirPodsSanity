//
//  AirPodsSanityApp.swift
//  AirPods Sanity
//
//  Created by Tobias Punke on 25.08.22.
//
//  https://sarunw.com/posts/swiftui-menu-bar-app/
//  https://sarunw.com/posts/how-to-make-macos-menu-bar-app/
//  https://github.com/rnine/SimplyCoreAudio
//

import SwiftUI

@main
struct AirPodsSanityApp: App
{
	@NSApplicationDelegateAdaptor(AppDelegate.self) private var _AppDelegate

	@StateObject private var _AirPodsObserver = AirPodsObserver()

	var body: some Scene
	{
		WindowGroup
		{
			ContentView()
				.environmentObject(self._AirPodsObserver)
				.hidden()
		}
	}
}
