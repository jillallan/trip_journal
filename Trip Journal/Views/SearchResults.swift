//
//  SearchResults.swift
//  Trip Journal
//
//  Created by Jill Allan on 12/11/2022.
//

import MapKit
import SwiftUI

struct SearchResults: View {
    @ObservedObject var viewModel: TripViewModel
    @ObservedObject var locationQuery: LocationQuery
    @State var isPresented: Bool = false
    @Environment(\.dismiss) var dismiss
    @Environment(\.dismissSearch) private var dismissSearch
    
    var body: some View {
        ForEach(locationQuery.searchResults, id: \.self) { result in
            Button {
                isPresented.toggle()
            } label: {
                NavigationLink {
                    SearchResultMapView(result: result)
                    Text("\(result)")
                        .toolbar {
                            Button("Add") {
                                // Store the item here...
                                viewModel.addStep(for: result.placemark.coordinate)
                                dismiss()
                                dismissSearch()
                            }
                        }
                } label: {
                    VStack {
                        Text(result.placemark.title ?? "N/A")
                        Text(result.placemark.subLocality ?? "N/A")
                    }
                }
            }
        }
    }
}

struct SearchResults_Previews: PreviewProvider {
    static var previews: some View {
        SearchResults(viewModel: .preview, locationQuery: .preview)
    }
}
