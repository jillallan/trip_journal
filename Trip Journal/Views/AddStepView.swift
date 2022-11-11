//
//  TripViewMapAddStep.swift
//  Trip Journal
//
//  Created by Jill Allan on 07/11/2022.
//

import MapKit
import SwiftUI

struct AddStepView: View {
    @ObservedObject var viewModel: TripViewModel
    @State var region: MKCoordinateRegion
    @State private var searchText = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Map(coordinateRegion: $region)
                    .toolbar(.visible, for: .navigationBar)
                    .navigationTitle("Add Step")
                    .navigationBarTitleDisplayMode(.inline)
                    .ignoresSafeArea(edges: .bottom)
                    .toolbar {
                        Button {
                            dismiss()
                        } label: {
                            Label("Add", systemImage: "plus")
                        }
                    }
                    .searchable(text: $searchText)
                Circle()
                    .fill(.blue)
                    .opacity(0.3)
                    .frame(width: 32, height: 32)
            }
        }
        .onDisappear {
            viewModel.addStep(for: region.center)
            viewModel.setRegion(for: region.center)
        }
    }
}

struct AddStepView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = TripViewModel()
        AddStepView(viewModel: viewModel, region: viewModel.region)
    }
}
