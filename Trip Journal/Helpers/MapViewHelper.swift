//
//  RouteRenderer.swift
//  Trip Journal
//
//  Created by Jill Allan on 18/11/2022.
//

import Foundation
import MapKit

struct MapViewHelper {
    let locationManager: LocationManager
    
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
    
    func calculateMapRegionWihLocale() -> MKCoordinateRegion {
        print("locale func 1")
        let locale = Locale.current
        var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.5, longitude: 0.0),
            span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
        )
        if let regionCode = locale.language.region?.identifier {
            print("locale func 2 \(regionCode)")
            locationManager.fetchPlacemark(for: regionCode)
            if let coordinates = locationManager.fetchedPlacemark?.location?.coordinate {
                print("locale func 3 \(region)")
                region = MKCoordinateRegion(
                    center: coordinates,
                    span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
                )
            }
        }
        print("return from local func: \(region)")
        return region
        
    }
    
    func calculateMapRegion(from steps: [Step]) -> MKCoordinateRegion {
        
        if let maxLatitude = steps.map(\.latitude).max(),
           let minLatitude = steps.map(\.latitude).min(),
           let maxLongitude = steps.map(\.longitude).max(),
           let minLongitude = steps.map(\.longitude).min() {
            let centre = calculateCentreCoordinate(
                from: minLatitude,
                maxLatitude: maxLatitude,
                minLongitude: minLongitude,
                maxLongitude: maxLongitude
            )
            let span = calculateCoordinateSpan(
                from: minLatitude,
                maxLatitude: maxLatitude,
                minLongitude: minLongitude,
                maxLongitude: maxLongitude
            )
            return MKCoordinateRegion(center: centre, span: span)
        } else {
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 51.5, longitude: 0.0),
                span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
            )
        }
    }
    
    private func calculateCentreCoordinate(
        from minLatitude: Double,
        maxLatitude: Double,
        minLongitude: Double,
        maxLongitude: Double
    ) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: (minLatitude + maxLatitude) / 2,
            longitude: (minLongitude + maxLongitude) / 2
        )
    }
    
    private func calculateCoordinateSpan(
        from minLatitude: Double,
        maxLatitude: Double,
        minLongitude: Double,
        maxLongitude: Double
    ) -> MKCoordinateSpan {
        return MKCoordinateSpan(
            latitudeDelta: (maxLatitude - minLatitude) * 1.2,
            longitudeDelta: (maxLongitude - minLongitude) * 1.2
        )
    }
}
