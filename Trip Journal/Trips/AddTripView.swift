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
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var locationManager: LocationManager
    
    @State var title: String = ""
    @State var startDate: Date = Date.now
    @State var endDate: Date = Date.now
    @State var tripTrackingIsOn: Bool = false
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Init
    
    
    // MARK: - View
    
    var body: some View {
        Form {
            TextField("Trip Title", text: $title)
            DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
            DatePicker("End Date", selection: $endDate, displayedComponents: .date)
            Toggle("Enable Trip Tracking", isOn: $tripTrackingIsOn)
            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                Text("Select a photo")
            }
//            .onChange(of: selectedItem) { newValue in
//                Task {
//                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
//                        selectedImageData = data
//                    }
//                }
//            }
            Button {
                addTrip(
                    title: title,
                    startDate: startDate,
                    endDate: endDate
                )
                if tripTrackingIsOn {
                    locationManager.startLocationServices()
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
    
    // MARK: - Update Model Methods
    
    func addTrip(title: String, startDate: Date, endDate: Date) {
        _ = Trip(context: dataController.container.viewContext, title: title, startDate: startDate, endDate: endDate)
        dataController.save()
    }
}

// MARK: - Xcode Preview

struct AddTripView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripView()
    }
}
