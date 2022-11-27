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
    @StateObject var viewModel: AddStepViewModel
    @State private var isFeatureAnnotationCardViewPresented: Bool = false

    @Environment(\.dismissSearch) private var dismissSearch
    @Environment(\.dismiss) var dismiss

    // MARK: - Init
    
    init(coordinate: CLLocationCoordinate2D, trip: Trip, dataController: DataController) {
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        let viewModel = AddStepViewModel(region: region, trip: trip, dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - View
    
    var body: some View {
        let _ = print("view: \(viewModel.region.center)")
        let _ = Self._printChanges()
        NavigationStack {
            VStack {
                ZStack {
                    let _ = Self._printChanges()
                    MapView(
                        coordinateRegion: viewModel.region,
                        annotationItems: nil,
                        routeOverlay: nil,
                        onRegionChange: nil
                    ) { annotation in
                        print("Add step: \(annotation.coordinate)")
                        viewModel.featureAnnotation = annotation
                        isFeatureAnnotationCardViewPresented = true
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
                    .searchable(text: $viewModel.searchQuery) {
                        List(viewModel.searchResults) { result in
                            NavigationLink {
                                SearchResultMapView(result: result)
                                .toolbar {
                                    Button("Add") {
                                        viewModel.addStep(for: result.placemark.coordinate, name: result.name ?? "New Step")
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
                    .sheet(isPresented: $isFeatureAnnotationCardViewPresented) {
                        if let featureAnnotation = viewModel.featureAnnotation {
                            FeatureAnnotationCardView(featureAnnotation: featureAnnotation) { mapItem in
                                if let mapItem = mapItem {
                                    print("map item coordinates: \(mapItem.placemark.coordinate)")
                                    viewModel.addStep(for: mapItem.placemark.coordinate, name: mapItem.name ?? "New Step")
                                    viewModel.setRegion(for: mapItem.placemark.coordinate)
                                    dismiss()
                                }
                            }
                        }
                    }
                }
            }
        }
        .environmentObject(viewModel)
    }
}

//    .onDisappear {
//        print("dissapper")
//        if stepAdded {
//            viewModel.setRegion(with: currentMapRegion)
//        }
//    }

        


// MARK: - Xcode preview

//struct AddStepView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddStepView(
//            viewModel: .preview,
//            region: MKCoordinateRegion(
//                center: CLLocationCoordinate2D(latitude: 51.5, longitude: 0),
//                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
//            )
//        )
//    }
//}
