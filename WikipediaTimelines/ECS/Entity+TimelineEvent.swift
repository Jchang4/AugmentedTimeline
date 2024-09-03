//
//  Entity+TimelineEvent.swift
//  WikipediaTimelines
//
//  Created by Justin Chang on 9/3/24.
//

import Foundation
import RealityKit

class TimelineEvent {
    let date: Date
    let name: String
    let description: String
    let entity: ModelEntity = .init()

    init(event: EventPayload) {
        self.date = event.date
        self.name = event.name
        self.description = event.description
    }
}
