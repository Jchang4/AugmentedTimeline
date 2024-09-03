//
//  ContentView.swift
//  WikipediaTimelines
//
//  Created by Justin Chang on 9/3/24.
//

import RealityKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ToggleImmersiveSpaceButton()
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
