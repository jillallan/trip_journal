//
//  FeatureAnnotationCardView.swift
//  Trip Journal
//
//  Created by Jill Allan on 22/11/2022.
//

import MapKit
import SwiftUI
import Contacts

struct FeatureAnnotationCardView: View {
    
    @EnvironmentObject var dataController: DataController
    @Binding var stepAdded: Bool
    
    enum LoadingState {
        case loading, loaded, failed
    }
   
    let trip: Trip
    let featureAnnotation: MKAnnotation
    @State private var loadingState = LoadingState.loading
    @State var mapItem: MKMapItem?
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack {
            Group {
                switch loadingState {
                case .loaded:
                    if let mapItem = mapItem {
                        Image(systemName: mapItem.pointOfInterestCategory?.symbolName ?? "mappin.and.ellipse")
                        VStack {
                            Text(mapItem.name ?? "No name available")
                                .font(.title)
                            Text("\(mapItem.placemark.locality ?? "Unknown city")")
                        }
                        HStack {
                            Button("Add step") {
                                addStep(for: mapItem.placemark.coordinate, name: mapItem.name ?? "New step")
                                stepAdded = true
                                dismiss()
                            }
                            Button("Cancel", role: .cancel) {
                                dismiss()
                            }
                        }
                    } else {
                        Text("Could not get details of map item, no internet??")
                    }
                case .loading:
                    Text("Loading…")
                case .failed:
                    Text("Could not get details of map item")
                }
            }
        }
        .task {
            mapItem = await getMapItem(with: featureAnnotation)
            loadingState = .loaded
        }
    }
    
    func getMapItem(with annotation: MKAnnotation) async -> MKMapItem? {
        if let featureAnnotation = annotation as? MKMapFeatureAnnotation {
            do {
                let featureRequest = MKMapItemRequest(mapFeatureAnnotation: featureAnnotation)
                let featureItem = try await featureRequest.mapItem
                return featureItem
            } catch {
                fatalError("Failed to get map item: \(error.localizedDescription)")
            }
        } else {
            return nil
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
}

//struct FeatureAnnotationCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        FeatureAnnotationCardView()
//    }
//}
