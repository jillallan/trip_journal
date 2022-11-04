//
//  AddStepView.swift
//  Trip Journal
//
//  Created by Jill Allan on 04/11/2022.
//

import MapKit
import SwiftUI

struct AddStepView: View {
    @ObservedObject var viewModel: MapViewModel
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 50, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
    )
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Map(coordinateRegion: $region)
                .toolbar(.visible, for: .navigationBar)
                .navigationTitle("Add Step")
                .navigationBarTitleDisplayMode(.inline)
                .searchable(text: $searchText)
                .ignoresSafeArea(edges: .bottom)
                .toolbar {
                    Button {
                        viewModel.addStep(for: region.center)
                        dismiss()
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
        }
        
    }
}

struct AddStepView_Previews: PreviewProvider {
    static var previews: some View {
        AddStepView(viewModel: MapViewModel())
    }
}
