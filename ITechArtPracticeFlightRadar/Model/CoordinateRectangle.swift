//
//  CoordinateRectangle.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/7/21.
//

import Foundation
import MapKit

struct CoordinateRectangle {
    
    private let region: MKCoordinateRegion
    
    init(region: MKCoordinateRegion) {
        self.region = region
    }
    
    var minLatitude: CLLocationDegrees {
        let centerLat = region.center.latitude
        let latDelta = region.span.latitudeDelta
        let minLat = centerLat - latDelta
        return minLat
    }
    
    var minLongitude: CLLocationDegrees {
        let centerLon = region.center.longitude
        let lonDelta = region.span.longitudeDelta
        let minLongitude = centerLon - lonDelta
        return minLongitude
    }
    
    var maxLatitude: CLLocationDegrees {
        let centerLat = region.center.latitude
        let latDelta = region.span.latitudeDelta
        let maxLatitude = centerLat + latDelta
        return maxLatitude
    }
    
    var maxLongitude: CLLocationDegrees {
        let centerLon = region.center.longitude
        let lonDelta = region.span.longitudeDelta
        let maxLongitude = centerLon + lonDelta
        return maxLongitude
    }
    
}
