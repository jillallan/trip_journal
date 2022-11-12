//
//  DetailView.swift
//  Trip Journal
//
//  Created by Jill Allan on 11/11/2022.
//

import MapKit
import SwiftUI

struct DetailView: View {
    @ObservedObject var viewModel: TripViewModel
    let item: MKMapItem

    @Environment(\.dismiss) private var dismiss
    @Environment(\.dismissSearch) private var dismissSearch
    @Environment(\.isSearching) private var isSearching

    var body: some View {
        NavigationStack {
            Text("Information about \(item).")
//            Map(coordinateRegion: MKCoordinateRegion(center: item.placemark.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)))
                .toolbar(.visible, for: .navigationBar)
                .toolbar {
                    Button("Add") {
                        // Store the item here...
                        
                        viewModel.region.center = item.placemark.coordinate
                        print(isSearching)
                        dismiss()
                        dismissSearch()
                        print(isSearching)
                    }
                }
            .navigationTitle("Add view")
        }
    }
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView(item: "a")
//    }
//}
