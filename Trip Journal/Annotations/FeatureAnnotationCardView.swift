//
//  FeatureAnnotationCardView.swift
//  Trip Journal
//
//  Created by Jill Allan on 22/11/2022.
//

import MapKit
import SwiftUI
import Contacts
import PhotosUI

struct FeatureAnnotationCardView: View {
    
    @EnvironmentObject var dataController: DataController
    @State var date: Date
    
    enum LoadingState {
        case loading, loaded, failed
    }
   
    let trip: Trip
    let featureAnnotation: MKAnnotation
    @State private var loadingState = LoadingState.loading
    @State var mapItem: MKMapItem?
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        Group {
            switch loadingState {
            case .loaded:
                if let clLocation = mapItem?.placemark.location {
                    AddEntryDetailView(trip: trip, clLocation: clLocation, date: date, name: mapItem?.placemark.name ?? "New Entry")
                
                } else {
                    Text("Could not get details of map item, no internet??")
                }
            case .loading:
                NavigationStack {
                    VStack {
                        
                    }
                    .navigationTitle("Loading")
                }
                
            case .failed:
                NavigationStack {
                    VStack {
                        
                    }
                    .navigationTitle("Could not get details of map item")
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
}

//struct FeatureAnnotationCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        FeatureAnnotationCardView()
//    }
//}
