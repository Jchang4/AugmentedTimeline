//
//  ImmersiveView.swift
//  WikipediaTimelines
//
//  Created by Justin Chang on 9/3/24.
//

import RealityKit
import RealityKitContent
import SwiftUI

struct ImmersiveView: View {
    init() {
        GlobalAppState.shared.events = TimelineHandler
            .getEvents()!
            .sorted(by: { $0.date <= $1.date })
            .map { TimelineEvent(event: $0) }
    }

    var body: some View {
        ZStack {
            RealityView { content in
                let root = GlobalAppState.shared.root
                root.position = [0, 1.2, -1.1]

                let line = createTimelineLine()
                root.addChild(line)

                for event in GlobalAppState.shared.events {
                    root.addChild(event.entity)
                }

                // Reposition all events
                GlobalAppState.shared.repositionEvents()

                content.add(root)
            }

            ForEach(GlobalAppState.shared.events, id: \.entity.id) { event in
                TimelineEventView(event: event)
            }
        }
    }

    func createTimelineLine() -> Entity {
        let line = Entity()
        line.name = "Line"

        let lineModel = ModelEntity(mesh: .generateCylinder(height: 2, radius: 0.01), materials: [SimpleMaterial(color: .black, isMetallic: false)])
        lineModel.name = "LineModel"
        lineModel.transform.rotation = .init(angle: deg2rad(90), axis: [1, 0, 0])
        lineModel.components.set(OpacityComponent(opacity: 0.65))

        line.addChild(lineModel)
        return line
    }
}

func deg2rad(_ number: Float) -> Float {
    return number * .pi / 180
}

func getDistanceFromDate(date: Date, dateRange: (Date, Date)) -> Double {
    let (startDate, endDate) = dateRange

    // Ensure the startDate is before or the same as endDate
    guard startDate <= endDate else {
        return 0.0
    }

    // Handle cases where the given date is before the startDate or after the endDate
    if date < startDate {
        return 0.0
    } else if date > endDate {
        return 1.0
    }

    // Calculate the total duration of the date range
    let totalDuration = endDate.timeIntervalSince(startDate)

    // Calculate the duration from the startDate to the given date
    let dateDuration = date.timeIntervalSince(startDate)

    // Calculate the percentage
    let percentage = dateDuration / totalDuration

    return percentage
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
}
