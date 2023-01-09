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
    @State var annotationsDidChange: Bool = false
    let locations: FetchedResults<Location>
    let trip: Trip
    let geo: GeometryProxy
    
    @State var selectedAnnotation: Location? = nil
    
    @State private var isLocationViewPresented: Bool = false
    @State private var isAddStepDetailViewPresented: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            let _ = print("fetchrequest count tripmap: \(locations.count)")
            let _ = Self._printChanges()
            MapView(
                coordinateRegion: MKCoordinateRegion(
                    center: coordinate,
                    span: span
                ),
                annotationItems: locations.map { $0 }, annotationsDidChange: annotationsDidChange,
                routeOverlay: createRoute(from: locations.map(\.coordinate)), onAnnotationSelection:  { annotation in
                    selectedAnnotation = annotation as? Location
                    isLocationViewPresented = true
                })
        }
        .frame(height: geo.size.height * 0.65)
        
        .confirmationDialog("Location", isPresented: $isLocationViewPresented, titleVisibility: .visible) {
            if let selectedLocation = selectedAnnotation {
                if let location = locations.first(where: { $0 == selectedLocation }) {
                    if let step = location.step {
                        Button("Delete Step") {
                            delete(step)
                            annotationsDidChange = true
                        }
                    } else {
                        Button("Add Step ") { isAddStepDetailViewPresented = true }
                        Button("Delete Location") {
                            delete(location)
                            annotationsDidChange = true
                        }
                    }
                }
            }
        } message: {
            if let selectedAnnotation = selectedAnnotation {
                // TODO: - location lookup
                Text(selectedAnnotation.step?.stepName ?? String(describing: selectedAnnotation.locationTimestamp))
            }
        }

        .sheet(isPresented: $isAddStepDetailViewPresented) {
            annotationsDidChange = true
            selectedAnnotation = nil
        } content: {
            if let date = selectedAnnotation?.timestamp,
               let selectedAnnotation = selectedAnnotation {
                // TODO: - look up location details to pass name into view
                AddStepDetailView(trip: trip, location: selectedAnnotation, date: date, name: "New Step")
            }
        }
        

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
