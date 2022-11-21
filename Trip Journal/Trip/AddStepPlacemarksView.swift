//
//  AddStepPlacemarksView.swift
//  Trip Journal
//
//  Created by Jill Allan on 21/11/2022.
//

import CoreLocation
import SwiftUI

struct AddStepPlacemarksView: View {
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @ObservedObject var viewModel: TripViewModel
    @State private var loadingState = LoadingState.loading
    @State private var placemarks = [String]()
    @Binding var placemarkName: String
    @Environment(\.dismiss) var dismiss
    
    let coordinates: CLLocationCoordinate2D
    
    var body: some View {
        NavigationStack {
            Group {
                switch loadingState {
                case .loaded:
                    List(placemarks, id: \.self) { placemark in
                        HStack {
                            Text(placemark)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            print("cell tapped: \(placemark)")
                            placemarkName = placemark
                            dismiss()
                            // TODO: - Add confirmation name is selected
                        }
                    }
                case .loading:
                    Text("Loading…")
                case .failed:
                    Text("No places associated with these cooridnates")
                }
            }
            .navigationTitle("Places for coordinates")
            .navigationBarTitleDisplayMode(.inline)
        }
        
        .task {
            print(coordinates)
            placemarks = await viewModel.fetchPlacemarks(for: coordinates)
            loadingState = .loaded
        }
    }
}

struct AddStepPlacemarksView_Previews: PreviewProvider {
    static var previews: some View {
        AddStepPlacemarksView(viewModel: .preview, placemarkName: .constant("New Step"), coordinates: CLLocationCoordinate2D(latitude: 51.5, longitude: 0))
    }
}
