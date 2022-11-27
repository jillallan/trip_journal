//
//  AddTripView.swift
//  Trip Journal
//
//  Created by Jill Allan on 18/11/2022.
//

import SwiftUI

struct AddTripView: View {
    
    // MARK: - Properties
    
    @StateObject var viewModel: AddTripViewModel
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Init
    
    init(dataController: DataController, locationManager: LocationManager) {
        let viewModel = AddTripViewModel(dataController: dataController, locationManager: locationManager)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - View
    
    var body: some View {
        Form {
            TextField("Trip Title", text: $viewModel.title)
            DatePicker("Start Date", selection: $viewModel.startDate, displayedComponents: .date)
            DatePicker("End Date", selection: $viewModel.endDate, displayedComponents: .date)
            Toggle("Enable Trip Tracking", isOn: $viewModel.tripTrackingIsOn)
            
            Button {
                viewModel.addTrip(
                    title: viewModel.title,
                    startDate: viewModel.startDate,
                    endDate: viewModel.endDate
                )
                if viewModel.tripTrackingIsOn {
                    viewModel.locationManager.startLocationServices()
                }
                dismiss()
            } label: {
                Text("Add Trip")
            }

        }
    }
}

// MARK: - Xcode Preview

struct AddTripView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripView(dataController: .preview, locationManager: .preview)
    }
}
