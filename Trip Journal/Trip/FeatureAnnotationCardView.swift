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
    
    enum LoadingState {
        case loading, loaded, failed
    }
   
    @StateObject var viewModel: FeatureAnnotationCardViewModel
    @State private var loadingState = LoadingState.loading
    @State var addStep: ((MKMapItem?) -> Void)?
    @Environment(\.dismiss) var dismiss
    

    init(featureAnnotation: MKMapFeatureAnnotation, addStep: ((MKMapItem?) -> Void)?) {
        let viewModel = FeatureAnnotationCardViewModel(featureAnnotation: featureAnnotation, addStep: addStep)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        HStack {
            Group {
                switch loadingState {
                case .loaded:
                    if let mapItem = viewModel.mapItem {
                        Image(systemName: mapItem.pointOfInterestCategory?.symbolName ?? "mappin.and.ellipse")
                        VStack {
                            Text(mapItem.name ?? "No name available")
                                .font(.title)
                            Text("\(mapItem.placemark.locality ?? "Unknown city")")
                        }
                        HStack {
                            Button("Add step") {
                                if let addStep = viewModel.addStep {
                                    addStep(mapItem)
                                }
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
            viewModel.mapItem = await viewModel.getMapItem(with: viewModel.featureAnnotation)
            loadingState = .loaded
        }
    }
}

//struct FeatureAnnotationCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        FeatureAnnotationCardView()
//    }
//}
