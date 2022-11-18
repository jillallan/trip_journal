//
//  RouteRenderer.swift
//  Trip Journal
//
//  Created by Jill Allan on 18/11/2022.
//

import Foundation
import MapKit

struct RouteRenderer {
    let coordinates: [CLLocationCoordinate2D]
    
    func createRoute() -> [MKPolyline] {
        var tripRoute = [MKPolyline]()
        var tripRouteStart = coordinates
        var tripRouteEnd = coordinates

        tripRouteStart.removeLast()
        tripRouteEnd.removeFirst()

        for (startCoordinate, endCoordinate) in zip(tripRouteStart, tripRouteEnd) {
            let polyline = MKPolyline(coordinates: [startCoordinate, endCoordinate], count: 2)
            tripRoute.append(polyline)
            
        }
        return tripRoute
    }
}
