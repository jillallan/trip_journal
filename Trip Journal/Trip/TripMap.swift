//
//  TripMap.swift
//  Trip Journal
//
//  Created by Jill Allan on 30/12/2022.
//

import MapKit
import SwiftUI

struct TripMap: View {
    @EnvironmentObject var dataController: DataController
    @Binding var coordinate: CLLocationCoordinate2D
    @Binding var span: MKCoordinateSpan
    let locations: FetchedResults<Location>
    let steps: FetchedResults<Step>
    let geo: GeometryProxy
    
    @State var selectedAnnotation: Location!
    
    @State private var locationViewIsPresented: Bool = false
    
    var body: some View {
        ZStack {
            
            MapView(
                coordinateRegion: MKCoordinateRegion(
                    center: coordinate,
                    span: span
                ),
                annotationItems: locations.map { $0 },
                routeOverlay: createRoute(from: locations.map(\.coordinate)), onAnnotationSelection:  { annotation in
                    selectedAnnotation = annotation as? Location
                    locationViewIsPresented = true
                    
                })
        }
        .onAppear {
            print("steps count: \(steps.count)")
            print("locations count: \(locations.count)")
        }
        .frame(height: geo.size.height * 0.65)
        
        .confirmationDialog("Location", isPresented: $locationViewIsPresented, actions: {
            if let selectedAnnotation = selectedAnnotation {
                if let location = locations.first(where: { $0 == selectedAnnotation }) {
                    if let step = location.step {
                        Button("Delete Step") {
                            delete(step)
                        }
                    } else {
                        Button("Add Step ") {
                            // TODO: -
                        }
                        Button("Delete Location") {
                            delete(location)
                        }
                    }
                }
            }
        }, message: {
            if let selectedAnnotation = selectedAnnotation {
                // TODO: - location lookup
                Text(selectedAnnotation.step?.stepName ?? String(describing: selectedAnnotation.locationTimestamp))
            }
            
        })
    }
    
    func createRoute(from coordinates: [CLLocationCoordinate2D]) -> [MKPolyline] {
        var route = [MKPolyline]()

        if !coordinates.isEmpty {
            var tripRouteStart = coordinates
            var tripRouteEnd = coordinates
            
            tripRouteStart.removeLast()
            tripRouteEnd.removeFirst()
            
            for (startCoordinate, endCoordinate) in zip(tripRouteStart, tripRouteEnd) {
                let polyline = MKPolyline(coordinates: [startCoordinate, endCoordinate], count: 2)
                route.append(polyline)
                
            }
        }
        return route
    }
    
    func delete(_ step: Step) {
        if let location = step.location {
            if location.distance == 0 && location.horizontalAccuracy == 0 {
                delete(location)
            }
            dataController.delete(step)
        }
        dataController.save()
    }
    
    func delete(_ location: Location) {
//        location.step = nil
        dataController.delete(location)
        dataController.save()
    }
}


//struct TripMap_Previews: PreviewProvider {
//    static var previews: some View {
//        TripMap()
//    }
//}
