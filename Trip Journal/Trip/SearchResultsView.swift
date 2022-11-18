//
//  SearchResults.swift
//  Trip Journal
//
//  Created by Jill Allan on 12/11/2022.
//

import MapKit
import SwiftUI

struct SearchResultsView: View {
    @ObservedObject var viewModel: TripViewModel
    @ObservedObject var locationQuery: LocationQuery
    @Environment(\.dismiss) var dismiss
    @Environment(\.dismissSearch) private var dismissSearch
    
    var body: some View {

        NavigationStack {
            List(locationQuery.searchResults) { result in
                NavigationLink {
                    SearchResultMapView(searchResult: result)
                    .toolbar {
                        Button("Add") {
                            // Store the item here...
                            dismiss()
                            dismissSearch()
                            viewModel.addStep(for: result.placemark.coordinate)
                        }
                    }
                } label: {
                    SearchResultCellView(result: result)
                }
            }
        }
//        .frame(height: .infinity)
        
//        ForEach(locationQuery.searchResults) { result in
//            Button {
//                isPresented.toggle()
//            } label: {
//                NavigationLink {
//                    SearchResultMapView(result: result)
//                    Text("\(result)")
//                        .toolbar {
//                            Button("Add") {
//                                // Store the item here...
//                                viewModel.addStep(for: result.placemark.coordinate)
//                                dismiss()
//                                dismissSearch()
//                            }
//                        }
//                } label: {
//                    SearchResultCellView(result: result)
//                }
//            }
//        }
    }
}

//struct SearchResults_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchResultsView(viewModel: .preview, locationQuery: .preview)
//    }
//}
