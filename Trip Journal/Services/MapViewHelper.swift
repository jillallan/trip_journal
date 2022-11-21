//
//  RouteRenderer.swift
//  Trip Journal
//
//  Created by Jill Allan on 18/11/2022.
//

import Foundation
import MapKit

struct MapViewHelper {
    
    func createRoute(from coordinates: [CLLocationCoordinate2D]) -> [MKPolyline] {
        
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
    
    // Consider passing in CLLocationCoordinate2D array instead of step array for below functions
    
    func calculateMapRegion(from steps: [Step]) -> MKCoordinateRegion {
        let centreCoordinate = calculateCentreCoordinate(from: steps)
        let coordinateSpan = calculateCoordinateSpan(from: steps)
        print("Mapviewhelper: \(centreCoordinate), \(coordinateSpan)")
        return MKCoordinateRegion(center: centreCoordinate, span: coordinateSpan)
    }
    
    private func calculateCentreCoordinate(from steps: [Step]) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: steps.map(\.latitude).reduce(0, +) / Double(steps.count),
            longitude: steps.map(\.longitude).reduce(0, +) / Double(steps.count)
        )
    }
    
    private func calculateCoordinateSpan(from steps: [Step]) -> MKCoordinateSpan {
        if let maxLatitude = steps.map(\.latitude).max(),
           let minLatitude = steps.map(\.latitude).min(),
           let maxLongitude = steps.map(\.longitude).max(),
           let minLongitude = steps.map(\.longitude).min() {
            print("map view helper: \(maxLatitude), \(minLatitude), \(maxLongitude), \(minLongitude)")
            return MKCoordinateSpan(
                latitudeDelta: (maxLatitude - minLatitude) * 1.2,
                longitudeDelta: (maxLongitude - minLongitude) * 1.2
            )
        } else {
            return MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
        }
    }
}
