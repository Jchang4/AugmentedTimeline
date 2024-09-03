//
//  AppModel.swift
//  WikipediaTimelines
//
//  Created by Justin Chang on 9/3/24.
//

import RealityKit
import SwiftUI

@Observable
class GlobalAppState {
    static let shared = GlobalAppState()
    private init() {}

    let root: Entity = .init()
    var events: [TimelineEvent] = []

    func repositionEvents() {
        // Reposition all events
        let lineBounds = (root.findEntity(named: "LineModel")! as! ModelEntity).visualBounds(relativeTo: nil)
        let lineHeight = lineBounds.max[2] - lineBounds.min[2]
        for (index, event) in GlobalAppState.shared.events.enumerated() {
            let startDate = GlobalAppState.shared.events.first!.date
            let endDate = GlobalAppState.shared.events.last!.date
            let pctDistance = getDistanceFromDate(date: event.date, dateRange: (startDate, endDate))

            let positionX: Float = index % 2 == 0 ? 0.5 : -0.5
            let positionZ: Float = lineHeight / 2 - Float(pctDistance) * lineHeight

            let prevEvent = index > 1 ? GlobalAppState.shared.events[index - 2] : nil
            let distanceFromPrev = (prevEvent?.entity.position[2] ?? 999) - positionZ
            let positionY: Float = getPositionY(prevEvent: distanceFromPrev < 0.2 ? prevEvent : nil)

            event.entity.position = [positionX, positionY, positionZ]
        }
    }

    func getPositionY(prevEvent: TimelineEvent?) -> Float {
        if prevEvent == nil {
            return 0.1
        }

        let prevHeight = prevEvent?.entity.position.y ?? 0.1
        return prevHeight > 0.1 ? -0.4 : 0.4
    }
}
