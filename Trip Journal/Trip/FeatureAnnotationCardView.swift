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
   
    
    @ObservedObject var viewModel: TripViewModel
    @State var featureAnnotation: MKMapFeatureAnnotation
    @State var mapItem = MKMapItem()
    @Binding var placemarkName: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack {
            Image(systemName: mapItem.pointOfInterestCategory?.symbolName ?? "mappin.and.ellipse")
            VStack {
                Text(mapItem.name ?? "No name available")
                    .font(.title)
                Text("\(mapItem.placemark.locality ?? "Unknown city")")
            }
            HStack {
                Button("Add step") {
                    viewModel.addStep(for: mapItem.placemark.coordinate, name: mapItem.name ?? "New step")
                    placemarkName = mapItem.name ?? "New step"
                    dismiss()
                }
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }
        }
        .task {
            mapItem = await viewModel.getMapItem(with: featureAnnotation)
        }
    }
}

//struct FeatureAnnotationCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        FeatureAnnotationCardView()
//    }
//}
