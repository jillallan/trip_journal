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
    let steps: FetchedResults<Step>
    let trip: Trip
    let geo: GeometryProxy
    
    @State var selectedAnnotation: Step? = nil
    
    @State private var isStepViewPresented: Bool = false
    @State private var isAddEntryDetailViewPresented: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        let annotationBinding = Binding(
            get: { self.selectedAnnotation as (any MKAnnotation)? },
            set: { self.selectedAnnotation = $0 as? Step }
        )
        
        
        return ZStack {
            
            MapView2(
                centre: $coordinate,
                span: $span,
//                coordinateRegion: MKCoordinateRegion(center: coordinate, span: span),
                annotationItems: steps.map { $0 },
                annotationsDidChange: annotationsDidChange,
                routeOverlay: createRoute(from: steps.map(\.coordinate)),
                selectedAnnotation: annotationBinding)
            
//            MapView(
//                coordinateRegion: MKCoordinateRegion(
//                    center: coordinate,
//                    span: span
//                ),
//                annotationItems: steps.map { $0 }, annotationsDidChange: annotationsDidChange,
//                routeOverlay: createRoute(from: steps.map(\.coordinate)), onAnnotationSelection:  { annotation in
//                    selectedAnnotation = annotation as? Location
//                    isLocationViewPresented = true
//                })
        }
        .frame(height: geo.size.height * 0.65)
        
        .confirmationDialog("Location", isPresented: $isStepViewPresented, titleVisibility: .visible) {
            if let selectedLocation = selectedAnnotation {
                if let step = steps.first(where: { $0 == selectedLocation }) {
                    if let entry = step.entry {
                        Button("Delete Entry") {
                            delete(entry)
                            annotationsDidChange = true
                        }
                    } else {
                        Button("Add Entry") { isAddEntryDetailViewPresented = true }
                        Button("Delete Location") {
                            delete(step)
                            annotationsDidChange = true
                        }
                    }
                }
            }
        } message: {
            if let selectedAnnotation = selectedAnnotation {
                // TODO: - location lookup
                Text(selectedAnnotation.entry?.entryName ?? String(describing: selectedAnnotation.stepTimestamp))
            }
        }

        .sheet(isPresented: $isAddEntryDetailViewPresented) {
            annotationsDidChange = true
            selectedAnnotation = nil
        } content: {
            if let date = selectedAnnotation?.timestamp,
               let selectedAnnotation = selectedAnnotation {
                // TODO: - look up location details to pass name into view
                AddEntryDetailView(trip: trip, step: selectedAnnotation, date: date, name: "New Entry")
            }
        }
        
        .onChange(of: selectedAnnotation) { newValue in
            isStepViewPresented = true
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
        if let step = entry.step {
            if step.distance == 0 && step.horizontalAccuracy == 0 {
                delete(step)
            }

            dataController.delete(entry)
        }
        dataController.save()
    }
    
    func delete(_ step: Step) {
        
//        step.entry = nil
        dataController.delete(step)
        dataController.save()
    }
}


//struct TripMap_Previews: PreviewProvider {
//    static var previews: some View {
//        TripMap()
//    }
//}
