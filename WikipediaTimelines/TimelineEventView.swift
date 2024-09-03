//
//  TimelineEventView.swift
//  WikipediaTimelines
//
//  Created by Justin Chang on 9/3/24.
//

import RealityKit
import SwiftUI

struct TimelineEventView: View {
    let event: TimelineEvent

    init(event: TimelineEvent) {
        self.event = event

        let bounds = event.entity.visualBounds(relativeTo: nil)
        let width = bounds.max[0] - bounds.min[0]
        let height = bounds.max[1] - bounds.min[1]
        let depth = bounds.max[2] - bounds.min[2]

        event.entity.components.set(InputTargetComponent())
        event.entity.components.set(CollisionComponent(
            shapes: [.generateBox(width: width, height: height, depth: depth)]
        ))
    }

    var body: some View {
        RealityView { _, _ in

        } update: { _, attachments in
            if let descriptionAttachment = attachments.entity(for: "EventDescription") {
                descriptionAttachment.removeFromParent()
                event.entity.addChild(descriptionAttachment)
            }
        } attachments: {
            Attachment(id: "EventDescription") {
                VStack(alignment: .leading) {
                    Text("\(formatDateToMMDDYYYY(date: event.date)) - \(event.name)")
                        .font(.extraLargeTitle)
                    ScrollView {
                        Text("\(event.description)")
                            .font(.largeTitle)
                    }

                    Button("See More") {
                        let root = GlobalAppState.shared.root
                        var events = GlobalAppState.shared.events

                        // Add new children to root and events array
                        for newEvent in TimelineHandler
                            .getEvents(file: .response)!
                            .map({ TimelineEvent(event: $0) })
                            .filter({ currEvent in
                                GlobalAppState.shared.events.first(where: { existingEvent in
                                    existingEvent.date == currEvent.date
                                }) == nil
                            })
                        {
                            events.append(newEvent)
                            root.addChild(newEvent.entity)
                        }

                        // Update global state
                        GlobalAppState.shared.events = events.sorted(by: { $0.date < $1.date })

                        // Reposition all events
                        GlobalAppState.shared.repositionEvents()
                    }
                    .controlSize(.extraLarge)
                }
                .frame(width: 750)
                .frame(maxHeight: 300)
                .padding(.all, 30)
                .glassBackgroundEffect()
            }
        }
    }

    func formatDateToMMDDYYYY(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy" // Note: lowercase 'dd' for day
        return dateFormatter.string(from: date)
    }
}
