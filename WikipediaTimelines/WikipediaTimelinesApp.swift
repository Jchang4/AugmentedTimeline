//
//  WikipediaTimelinesApp.swift
//  WikipediaTimelines
//
//  Created by Justin Chang on 9/3/24.
//

import SwiftUI

@main
struct WikipediaTimelinesApp: App {
    @State private var appModel = AppModel()
    @State private var avPlayerViewModel = AVPlayerViewModel()

    var body: some Scene {
        ImmersiveSpace(id: "TimelineImmersive") {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                    avPlayerViewModel.play()
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                    avPlayerViewModel.reset()
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
