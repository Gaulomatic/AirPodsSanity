//
//  ContentView.swift
//  AirPods Sanity
//
//  Created by Tobias Punke on 25.08.22.
//

import SwiftUI
import AppKit

struct ContentView: View
{
	var body: some View
	{
		Text("Keep your sanity in check!")
			.padding()
	}
}

struct ContentView_Previews: PreviewProvider
{
	static var previews: some View
	{
		ContentView()
			.environmentObject(AirPodsObserver())
	}
}
