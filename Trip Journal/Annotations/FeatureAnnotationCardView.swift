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
                if let mapItem = mapItem {
                    NavigationStack {
                        VStack {
                            Spacer()
                            DatePicker("Date", selection: $date)
                                .padding()
                            Button("Add step") {
                                addStep(for: mapItem.placemark, name: mapItem.name ?? "New Step", trip: trip, date: date)
                                
                                stepAdded = true
                                dismiss()
                            }
                        }
                        
                            .navigationTitle(mapItem.name ?? "No name available")
                        
                    }
                    .toolbar {
                        Button("Cancel", role: .cancel) {
                            dismiss()
                        }
                    }
                
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
    
    func addStep(for placemark: CLPlacemark, name: String, trip: Trip, date: Date) {
        if let stepLocation = placemark.location {
            
            let location = Location(context: dataController.container.viewContext, cLlocation: stepLocation)
            
            let step = Step(context: dataController.container.viewContext, coordinate: location.coordinate, timestamp: date, name: name)
            
            step.location = location
            step.trip = trip
            dataController.save()
        } else {
            print("Failed to add step")
        }
    }
}

//struct FeatureAnnotationCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        FeatureAnnotationCardView()
//    }
//}
