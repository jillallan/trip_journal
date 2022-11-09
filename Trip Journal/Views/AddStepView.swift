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
            let _ = print("Update TripViewMapAddStep \(Date.now)")
            let _ = Self._printChanges()
            ZStack {
                Map(coordinateRegion: $region)
//                MapViewSimple(coordinateRegion: $region, callback: { coord in
//                    viewModel.setRegion(for: coord)
//                })
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
        .onAppear {
            print("TripViewMapAddStep Will Appear")
        }
        .onDisappear {
            print("TripViewMapAddStep Will Disappear")
            print("will add step \(viewModel.steps.count)")
            viewModel.addStep(for: region.center)
            print("did add step \(viewModel.steps.count)")
        }
    }
}

struct AddStepView_Previews: PreviewProvider {
    static var previews: some View {
        AddStepView(
            viewModel: TripViewModel(),
            region: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 51.5, longitude: 0),
                span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
            )
        )
    }
}
