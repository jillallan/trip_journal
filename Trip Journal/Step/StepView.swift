//
//  StepView.swift
//  Trip Journal
//
//  Created by Jill Allan on 01/12/2022.
//

import PhotosUI
import SwiftUI

struct StepView: View {
    let columns = [
        GridItem(.fixed(200))
    ]
    
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var photoAssetManager: PhotoLibraryService
    @State var photoAssetIdentifiers = PHFetchResultCollection(fetchResult: .init())
    @ObservedObject var step: Step
    
    @State private var name: String
    @State private var timestamp: Date

    
    @State private var showingPhotoPicker = false
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedPhotos: [PhotosPickerItem] = []
    
    init(step: Step) {
        self.step = step
        _name = State(initialValue: step.stepName)
        _timestamp = State(initialValue: step.stepTimestamp)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView() {
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 3) {
                    ForEach(photoAssetIdentifiers, id: \.localIdentifier) { asset in
                        NavigationLink {
                            PhotoView(asset: asset)
                        } label: {
                            JournalImage(asset: asset)
                                .photoGridItemStyle(aspectRatio: 1, cornerRadius: 0)
                        }
                    }
                    
                    PhotosPicker(selection: $selectedPhotos, photoLibrary: .shared()) {
                        Label("Add photos", systemImage: "photo")
                    }
                    .padding()
                }
            }
            VStack(alignment: .leading) {
                DatePicker("Step Date", selection: $timestamp.onChange(updateStep))
            }
            .padding(.horizontal)
        }
        //            .navigationTitle(step.stepName)
        .navigationTitle($name.onChange(updateStep))
        .navigationBarTitleDisplayMode(.large)
        
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    delete(step)
                    dismiss()
                } label: {
                    Label("Delete", systemImage: "trash")
                        .labelsHidden()
                }
            }
        }
        //            .toolbarBackground(.hidden, for: .navigationBar)
        
        .onDisappear {
            dataController.save()
        }
        .onAppear {
            let assetIdentifiers = step.stepPhotoAssetIdentifiers.compactMap(\.assetIdentifier)
            photoAssetIdentifiers.fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: assetIdentifiers, options: nil)
        }
        
        // TODO: - check this works with multi picker
        .onChange(of: selectedPhotos) { photos in
            for photo in photos {
                Task {
                    addPhoto(photo: photo)
                    let assetIdentifiers = step.stepPhotoAssetIdentifiers.compactMap(\.assetIdentifier)
                    photoAssetIdentifiers.fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: assetIdentifiers, options: nil)
                }
            }
        }
    }
    
    func updateStep() {
        // TODO: - create new step location, delete old location if manually created
        // TODO: - manually created if distance and horizontal accuracy are 0 (and speed -1 ??)
        
        step.location?.objectWillChange.send()
        step.name = name
        step.timestamp = timestamp
    }
    
    func updateStepTimestamp() {
        // TODO: - create new step location, delete old location if manually created
        // TODO: - manually created if distance and horizontal accuracy are 0 (and speed -1 ??)
        
        step.location?.objectWillChange.send()
        step.timestamp = timestamp
        if step.location?.distance == 0 {
            // delete location
        }
    }
    
    func addPhoto(photo: PhotosPickerItem?) {
        if let photoIdentifier = photo?.itemIdentifier {
            let newPhoto = PhotoAssetIdentifier(context: dataController.container.viewContext, assetIdentifier: photoIdentifier)
            step.addToPhotoAssetIdentifiers(newPhoto)
            step.trip?.addToPhotoAssetIdentifiers(newPhoto)
            dataController.save()
        }
    }
    
    func delete(_ step: Step) {
        step.trip?.objectWillChange.send()
        step.location?.objectWillChange.send()
        // TODO: - Delete location if manually created
        
        dataController.delete(step)
        dataController.save()
    }

}

//struct StepView_Previews: PreviewProvider {
//    static var previews: some View {
//        StepView(step: .preview)
//    }
//}
