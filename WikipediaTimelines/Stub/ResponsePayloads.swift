//
//  ResponsePayloads.swift
//  WikipediaTimelines
//
//  Created by Justin Chang on 9/3/24.
//

import Foundation
import RealityKit

struct EventPayload: Codable {
    let date: Date
    let name: String
    let description: String
}

// Function to parse the date from various formats
func parseDate(from dateString: String) -> Date? {
    // Check for BCE/BC dates
    if dateString.contains("BCE") || dateString.contains("BC") {
        return parseBCEDate(from: dateString)
    }

    // Define possible date formats
    let dateFormats = [
        "yyyy", // e.g., "1984"
        "yyyy-MM", // e.g., "1984-12"
        "MMM yyyy", // e.g., "Oct 2022"
        "MMM dd yyyy", // e.g., "Jan 10 1922"
        "yyyy-MM-dd" // original format
    ]

    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")

    // Try parsing with each date format
    for format in dateFormats {
        dateFormatter.dateFormat = format
        if let date = dateFormatter.date(from: dateString) {
            return date
        }
    }

    // Return nil if no format matches
    return nil
}

// Function to parse BCE/BC dates
func parseBCEDate(from dateString: String) -> Date? {
    // Extract the year and convert to negative for BCE
    let yearString = dateString.replacingOccurrences(of: "BCE", with: "").replacingOccurrences(of: "BC", with: "").trimmingCharacters(in: .whitespaces)

    if let year = Int(yearString), year > 0 {
        var components = DateComponents()
        components.year = -year
        return Calendar.current.date(from: components)
    }
    return nil
}

enum EventFileType {
    case initial
    case response
}

class TimelineHandler {
    static func getEvents(file: EventFileType = .initial) -> [EventPayload]? {
        let filename = file == .initial ? "events-initial" : "events-response"
        guard let fileUrl = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("File not found")
            return nil
        }

        do {
            let data = try Data(contentsOf: fileUrl)
            let decoder = JSONDecoder()

            // Custom decoding to handle various date formats
            decoder.dateDecodingStrategy = .custom { decoder in
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                if let date = parseDate(from: dateString) {
                    return date
                } else {
                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
                }
            }

            let events = try decoder.decode([EventPayload].self, from: data)
            return events
        } catch {
            print("Error parsing JSON: \(error)")
            return nil
        }
    }
}
