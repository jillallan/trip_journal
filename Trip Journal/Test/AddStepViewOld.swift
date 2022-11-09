//
//  AddStepViewTest.swift
//  Trip Journal
//
//  Created by Jill Allan on 04/11/2022.
//
import MapKit
import SwiftUI

struct AddStepViewOld: View {
    @ObservedObject var viewModel: TripViewModelOld
    @State var region: MKCoordinateRegion
    @State private var searchText = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            let _ = print("Update AddStepView \(Date.now)")
            let _ = Self._printChanges()
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
        }
    }
}
//
//struct AddStepViewOld_Previews: PreviewProvider {
//
//    static var previews: some View {
//        @State var region = MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: 49, longitude: 0),
//            span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
//        )
//
//        AddStepView(viewModel: TripViewModel(persistanceController: PersistanceController()), region: region)
//    }
//}
