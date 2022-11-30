//
//  AddTripView.swift
//  Trip Journal
//
//  Created by Jill Allan on 18/11/2022.
//

import PhotosUI
import SwiftUI

struct AddTripView: View {
    
    // MARK: - Properties
    
    @StateObject var viewModel: AddTripViewModel
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
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
            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                Text("Select a photo")
            }
            .onChange(of: selectedItem) { newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                    }
                }
            }
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
            if let selectedImageData,
               let uiImage = UIImage(data: selectedImageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
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
