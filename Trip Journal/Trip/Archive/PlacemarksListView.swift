//
//  AddEntryPlacemarksView.swift
//  Trip Journal
//
//  Created by Jill Allan on 21/11/2022.
//

import CoreLocation
import SwiftUI

struct PlacemarksListView: View {
    enum LoadingState {
        case loading, loaded, failed
    }
    
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
            // update to placemarkslistviewmodel
//            placemarks = await viewModel.fetchPlacemarks(for: coordinates)
            loadingState = .loaded
        }
    }
}

//struct AddEntryPlacemarksView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlacemarksListView(viewModel: .preview, placemarkName: .constant("New Entry"), coordinates: CLLocationCoordinate2D(latitude: 51.5, longitude: 0))
//    }
//}
