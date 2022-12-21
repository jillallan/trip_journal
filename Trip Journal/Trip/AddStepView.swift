//
//  TripViewMapAddStep.swift
//  Trip Journal
//
//  Created by Jill Allan on 07/11/2022.
//

import MapKit
import SwiftUI

struct AddStepView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var dataController: DataController
    @State var wasStepAdded: Bool = false
    @State private var isFeatureAnnotationCardViewPresented: Bool = false
    @State private var featureAnnotation: MKMapFeatureAnnotation!
    @StateObject var searchQuery: SearchQuery

    @Environment(\.dismissSearch) private var dismissSearch
    @Environment(\.dismiss) var dismiss
    
    @State var region: MKCoordinateRegion
    let trip: Trip
    

    // MARK: - Init
    
    init(coordinate: CLLocationCoordinate2D, trip: Trip) {
        self.trip = trip
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        _region = State(initialValue: region)
        let searchQuery = SearchQuery(region: region)
        _searchQuery = StateObject(wrappedValue: searchQuery)
        
    }
    
    // MARK: - View
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    MapView(
                        coordinateRegion: region,
                        annotationItems: nil,
                        routeOverlay: nil,
                        onRegionChange: nil
                    ) { annotation in
                        featureAnnotation = annotation
                    }
                    .toolbar(.visible, for: .navigationBar)
                    .navigationTitle("Add Step")
                    .navigationBarTitleDisplayMode(.inline)
                    .ignoresSafeArea(edges: .bottom)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel", role: .cancel) {
                                dismiss()
                            }
                        }
                    }
                    .searchable(text: $searchQuery.searchQuery) {
                        List(searchQuery.searchResults) { result in
                            NavigationLink {
                                SearchResultMapView(result: result)
                                .toolbar {
                                    Button("Add") {
                                        addStep(for: result.placemark, name: result.name ?? "New Step")
                                        
//                                        addStep(for: result.placemark.coordinate, name: result.name ?? "New Step")
                                        dismiss()
                                        dismissSearch()
                                    }
                                }
                            } label: {
                                SearchResultCellView(result: result)
                            }
                        }
                        .frame(height: 400)
                    }
                    .onChange(of: featureAnnotation) { _ in
                        isFeatureAnnotationCardViewPresented = true
                    }
                    .onChange(of: wasStepAdded) { stepAdded in
                        if stepAdded {
                            dismiss()
                        }
                    }

                    // TODO: - On dismiss unselect annotation or do this in update view of MapView
          
                    
                    .sheet(isPresented: $isFeatureAnnotationCardViewPresented) {
                        if let featureAnnotation = featureAnnotation {
                            FeatureAnnotationCardView(stepAdded: $wasStepAdded, trip: trip, featureAnnotation: featureAnnotation)
                        }
                    }
                }
            }
        }
    }
    
    func addStep(for coordinate: CLLocationCoordinate2D, name: String) {
        let step = Step(
            context: dataController.container.viewContext,
            coordinate: coordinate,
            timestamp: Date.now,
            name: name
        )
        step.trip = trip
        dataController.save()
    }
    
    func addStep(for placemark: CLPlacemark, name: String) {
        if let stepLocation = placemark.location {
            
            let location = Location(context: dataController.container.viewContext, cLlocation: stepLocation)
            let step = Step(context: dataController.container.viewContext, coordinate: location.coordinate, timestamp: location.locationTimestamp, name: name)
            
            step.trip = trip
            step.location = location
            dataController.save()
        } else {
            print("Failed to add step")
        }
    }
    
    func setRegion(for coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    }
    
//    func getMapItem(with annotation: MKMapFeatureAnnotation) async -> MKMapItem {
//        let featureRequest = MKMapItemRequest(mapFeatureAnnotation: featureAnnotation)
//
//        do {
//            let featureItem = try await featureRequest.mapItem
//            return featureItem
//        } catch {
//            fatalError("Failed to get map item: \(error.localizedDescription)")
//        }
//    }
}

// MARK: - Xcode preview

struct AddStepView_Previews: PreviewProvider {
    static var previews: some View {
        
        AddStepView(coordinate: Step.preview.coordinate, trip: .preview)
    }
}
