//
//  TripsView.swift
//  Trip Journal
//
//  Created by Jill Allan on 18/11/2022.
//

import SwiftUI

struct TripsView: View {
    @EnvironmentObject var dataController: DataController
    @StateObject var viewModel: TripsViewModel
    @State var tripAddViewIsPresented: Bool = false
    
    init(dataController: DataController) {
        let viewModel = TripsViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            List(viewModel.trips) { trip in
                NavigationLink {
                    TripView(trip: trip, dataController: dataController)
//                    TripView(trip: trip, dataController: dataController)
                } label: {
                    VStack {
                        HStack {
                            Text(trip.tripTitle)
                            Spacer()
                            Text("Steps: \(trip.tripSteps.count)")
                        }
                        HStack {
                            Text(trip.tripStartDate, style: .date)
                            Spacer()
                            Text("-")
                            Spacer()
                            Text(trip.tripEndDate, style: .date)
                        }
                    }
                }
            }
            Text("test")
            .toolbar {
                Button {
                    tripAddViewIsPresented.toggle()
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $tripAddViewIsPresented) {
                AddTripView(viewModel: viewModel)
            }
        }
    }
}

//struct TripsView_Previews: PreviewProvider {
//    static var previews: some View {
//        TripsView()
//    }
//}
