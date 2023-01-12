//
//  TripViewMapAddEntry.swift
//  Trip Journal
//
//  Created by Jill Allan on 07/11/2022.
//

import MapKit
import SwiftUI
import PhotosUI

extension MKMapFeatureAnnotation {
     var mkAnnotation: MKAnnotation {
         get { self as any MKAnnotation }
         set { newValue as! MKMapFeatureAnnotation }
     }
 }


struct AddEntryView: View {
    
    // MARK: - View Properties
    
    @State var wasEntryAdded: Bool = false
    @State var isAddEntryViewPresented: Bool = true
//    @State private var featureAnnotation: MKMapFeatureAnnotation? = nil
    @State var featureAnnotation: MKMapFeatureAnnotation? = nil
    @StateObject var searchQuery: SearchQuery
    @Environment(\.dismissSearch) private var dismissSearch
    @Environment(\.dismiss) var dismiss
    
    
    // MARK: - Entry Properties
    let trip: Trip
    @State var date: Date
//    @State var region: MKCoordinateRegion
    @State var centre: CLLocationCoordinate2D
    @State var span: MKCoordinateSpan

    // MARK: - Init
    
    init(coordinate: CLLocationCoordinate2D, trip: Trip, date: Date) {
        self.trip = trip
        _centre = State(initialValue: coordinate)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        _span = State(initialValue: span)
//        let region = MKCoordinateRegion(center: coordinate, span: span)
//        _region = State(initialValue: region)
        let searchQuery = SearchQuery(region: MKCoordinateRegion(center: coordinate, span: span))
        _searchQuery = StateObject(wrappedValue: searchQuery)
        let tempDate = date.addingTimeInterval(60)
        _date = State(initialValue: tempDate)
    }
    
    // MARK: - View
    
    var body: some View {
        let annotationBinding = Binding(
            get: { self.featureAnnotation as (any MKAnnotation)? },
            set: { self.featureAnnotation = $0 as? MKMapFeatureAnnotation }
        )
        
        
        return NavigationStack {
            VStack {
                ZStack {
                    MapView2(
//                        coordinateRegion: $region,
                        centre: $centre,
                        span: $span,
                        annotationItems: nil,
                        annotationsDidChange: false,
                        routeOverlay: nil,
                        selectedAnnotation: annotationBinding
                    )

//                    MapView(
//                        coordinateRegion: region,
//                        annotationItems: nil,
//                        annotationsDidChange: false,
//                        routeOverlay: nil,
//                        onRegionChange: nil) { annotation in
//                            featureAnnotation = annotation as? MKMapFeatureAnnotation
//                        }
                        .toolbar(.visible, for: .navigationBar)
                        .navigationTitle("Add Entry")
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
                                    AddEntryDetailView(trip: trip, clLocation: CLLocation(latitude: result.placemark.coordinate.latitude, longitude: result.placemark.coordinate.longitude), date: date, name: result.name ?? "New Entry") {
                                        dismiss()
                                    }
                                } label: {
                                    SearchResultCellView(result: result)
                                }
                            }
                            .frame(height: 400)
                        }
                        .onChange(of: wasEntryAdded) { entryAdded in
                            if entryAdded {
                                dismiss()
                            }
                        }
                        .sheet(item: $featureAnnotation) {
                            featureAnnotation = nil
                            dismiss()
                        } content: { annotation in
                            if let annotation = annotation {
                                FeatureAnnotationCardView(date: date, trip: trip, featureAnnotation: annotation)
                            }
                        }
                }
            }
        }
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

//struct AddEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        AddEntryView(coordinate: Entry.preview.coordinate, trip: .preview)
//    }
//}
