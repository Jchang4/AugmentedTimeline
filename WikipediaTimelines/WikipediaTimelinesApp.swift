//
//  WikipediaTimelinesApp.swift
//  WikipediaTimelines
//
//  Created by Justin Chang on 9/3/24.
//

import SwiftUI

@main
struct WikipediaTimelinesApp: App {
    var body: some Scene {
        ImmersiveSpace(id: "TimelineImmersive") {
            ImmersiveView()
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
