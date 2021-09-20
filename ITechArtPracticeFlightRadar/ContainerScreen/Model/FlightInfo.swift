//
//  FlightInfo.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/8/21.
//

import Foundation

struct FlightInfo: Decodable {
    var timeStamp: Int
    var aircraft: [Aircraft]
    
    enum CodingKeys: String, CodingKey {
        case timeStamp = "time"
        case flights = "states"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.timeStamp = try container.decode(Int.self, forKey: .timeStamp)
        self.aircraft = try container.decode([Aircraft].self, forKey: .flights)
    }
}

struct Aircraft: Decodable {
    var transponderIdentifier: String
    var callsign: String?
    var countryOfRegistration: String
    var lastPositionTimeStamp: Int?
    var lastUpdateTimeStamp: Int
    var longitude: Float?
    var latitude: Float?
    var barometricAltitude: Float?
    var isOnGround: Bool
    var velocity: Float?
    var course: Float?
    
    enum CodingKeys: String, CodingKey {
        case transponderIdentifier = "icao24"
        case callsign
        case countryOfRegistration = "origin_country"
        case lastPositionTimeStamp = "time_position"
        case lastUpdateTimeStamp = "last_contact"
        case longitude
        case latitude
        case barometricAltitude = "baro_altitude"
        case isOnGround = "on_ground"
        case velocity
        case course = "true_track"
    }
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        guard container.count == 17 else {
            throw URLError(.cannotDecodeContentData)
        }
        
        transponderIdentifier = try container.decode(String.self)
        callsign = try? container.decode(String.self)
        countryOfRegistration = try container.decode(String.self)
        lastPositionTimeStamp = try? container.decode(Int.self)
        lastUpdateTimeStamp = try container.decode(Int.self)
        longitude = try? container.decode(Float.self)
        latitude = try? container.decode(Float.self)
        barometricAltitude = try? container.decode(Float.self)
        isOnGround = try container.decode(Bool.self)
        velocity = try? container.decode(Float.self)
        course = try? container.decode(Float.self)
    }
}

extension Aircraft: CustomStringConvertible {
    var description: String {
        return "Aircraft(\(transponderIdentifier), \(callsign ?? "<null>"), lon: \(longitude ?? 0), lat: \(latitude ?? 0), alt: \(barometricAltitude ?? 0) meters, speed: \(velocity ?? 0) m/s"
    }
}
