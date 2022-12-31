//
//  AddStepDetailView.swift
//  Trip Journal
//
//  Created by Jill Allan on 30/12/2022.
//

import SwiftUI
import PhotosUI

struct AddStepDetailView: View {
    @EnvironmentObject var dataController: DataController
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State var photoAssetIdentifiers = PHFetchResultCollection(fetchResult: .init())
    @State var selectedPhotosIdentifiers: [String] = []
    let trip: Trip
    let location: Location
    @State var date: Date
    @State var name = "New Step"
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        NavigationStack {
            VStack {
//                PhotosPicker(selection: $selectedPhotos, photoLibrary: .shared()) {
//                    Label("Add photos", systemImage: "photo")
//                }
//                .padding()
                Spacer()
//                DatePicker("Date", selection: $date)
//                    .padding()
                Button("Add step") {
                    addStep(for: location, name: name, trip: trip, date: date, photoAssetIdentifiers: selectedPhotosIdentifiers)
                    dismiss()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle($name)
            
        }
        .toolbar {
            Button("Cancel", role: .cancel) {
                dismiss()
            }
        }
        .onChange(of: selectedPhotos) { photos in
            for photo in photos {
                Task {
                    if let photoItemIdentifier = photo.itemIdentifier {
                        selectedPhotosIdentifiers.append(photoItemIdentifier)
                    }
                }
            }
            photoAssetIdentifiers.fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: selectedPhotosIdentifiers, options: nil)
        }
    }
    
//    func addPhoto(photo: PhotosPickerItem?) {
//        if let photoIdentifier = photo?.itemIdentifier {
//            let newPhoto = PhotoAssetIdentifier(context: dataController.container.viewContext, assetIdentifier: photoIdentifier)
//            step.addToPhotoAssetIdentifiers(newPhoto)
//            step.trip?.addToPhotoAssetIdentifiers(newPhoto)
//            dataController.save()
//        }
//    }
    
    func addStep(for location: Location, name: String, trip: Trip, date: Date, photoAssetIdentifiers: [String]) {
        
        let step = Step(context: dataController.container.viewContext, coordinate: location.coordinate, timestamp: date, name: name)
        
        step.location = location
        step.trip = trip
        trip.photoAssetIdentifiers = Set(photoAssetIdentifiers) as NSSet
        dataController.save()
    }
}

//struct AddStepDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddStepDetailView()
//    }
//}
