//
//  AddTripView.swift
//  Trip Journal
//
//  Created by Jill Allan on 18/11/2022.
//

import SwiftUI

struct AddTripView: View {
    @ObservedObject var viewModel: TripsViewModel
    @State var title: String = ""
    @State var startDate: Date = Date.now
    @State var endDate: Date = Date.now
    @State var tripTrackingIsOn: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            TextField("Trip Title", text: $title)
            DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
            DatePicker("End Date", selection: $endDate, displayedComponents: .date)
            Toggle("Enable Trip Tracking", isOn: $tripTrackingIsOn)
                .onChange(of: tripTrackingIsOn) { newValue in
                    viewModel.enableLocationTracking()
                }
            Button {
                viewModel.addTrip(title: title, startDate: startDate, endDate: endDate)
                viewModel.updateFetchRequest()
                dismiss()
            } label: {
                Text("Add Trip")
            }
        }
    }
}

struct AddTripView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripView(viewModel: .preview)
    }
}
