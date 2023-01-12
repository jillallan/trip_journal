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
    @State private var isAddEntryDetailViewPresented: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        let annotationBinding = Binding(
            get: { self.selectedAnnotation as (any MKAnnotation)? },
            set: { self.selectedAnnotation = $0 as? Location }
        )
        
        
        return ZStack {
            
            MapView2(
                centre: $coordinate,
                span: $span,
//                coordinateRegion: MKCoordinateRegion(center: coordinate, span: span),
                annotationItems: locations.map { $0 },
                annotationsDidChange: annotationsDidChange,
                routeOverlay: createRoute(from: locations.map(\.coordinate)),
                selectedAnnotation: annotationBinding)
            
//            MapView(
//                coordinateRegion: MKCoordinateRegion(
//                    center: coordinate,
//                    span: span
//                ),
//                annotationItems: locations.map { $0 }, annotationsDidChange: annotationsDidChange,
//                routeOverlay: createRoute(from: locations.map(\.coordinate)), onAnnotationSelection:  { annotation in
//                    selectedAnnotation = annotation as? Location
//                    isLocationViewPresented = true
//                })
        }
        .frame(height: geo.size.height * 0.65)
        
        .confirmationDialog("Location", isPresented: $isLocationViewPresented, titleVisibility: .visible) {
            if let selectedLocation = selectedAnnotation {
                if let location = locations.first(where: { $0 == selectedLocation }) {
                    if let entry = location.entry {
                        Button("Delete Entry") {
                            delete(entry)
                            annotationsDidChange = true
                        }
                    } else {
                        Button("Add Entry") { isAddEntryDetailViewPresented = true }
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
                Text(selectedAnnotation.entry?.entryName ?? String(describing: selectedAnnotation.locationTimestamp))
            }
        }

        .sheet(isPresented: $isAddEntryDetailViewPresented) {
            annotationsDidChange = true
            selectedAnnotation = nil
        } content: {
            if let date = selectedAnnotation?.timestamp,
               let selectedAnnotation = selectedAnnotation {
                // TODO: - look up location details to pass name into view
                AddEntryDetailView(trip: trip, location: selectedAnnotation, date: date, name: "New Entry")
            }
        }
        
        .onChange(of: selectedAnnotation) { newValue in
            isLocationViewPresented = true
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
    
    func delete(_ entry: Entry) {
        if let location = entry.location {
            if location.distance == 0 && location.horizontalAccuracy == 0 {
                delete(location)
            }

            dataController.delete(entry)
        }
        dataController.save()
    }
    
    func delete(_ location: Location) {
        
//        location.entry = nil
        dataController.delete(location)
        dataController.save()
    }
}


//struct TripMap_Previews: PreviewProvider {
//    static var previews: some View {
//        TripMap()
//    }
//}
