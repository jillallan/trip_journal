//
//  StepView.swift
//  Trip Journal
//
//  Created by Jill Allan on 01/12/2022.
//

import PhotosUI
import SwiftUI

struct StepView: View {
    let rows = [
        GridItem(.fixed(200))
    ]
    
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var photoAssetManager: PhotoLibraryService
    @State var photoAssetIdentifiers = PHFetchResultCollection(fetchResult: .init())
    @ObservedObject var step: Step
    
    @State private var name: String
    @State private var timestamp: Date

    
    @State private var showingPhotoPicker = false
    
    @State private var selectedPhoto: PhotosPickerItem?
    
    init(step: Step) {
        self.step = step
        _name = State(initialValue: step.stepName)
        _timestamp = State(initialValue: step.stepTimestamp)
    }
    
    var body: some View {
        VStack {
            Form {
                TextField("Step Name", text: $name.onChange(updateStep))
                DatePicker("Step Date", selection: $timestamp.onChange(updateStep))
                PhotosPicker("Add photo", selection: $selectedPhoto, photoLibrary: .shared())
            }
            ScrollView(.horizontal) {
                LazyHGrid(rows: rows, spacing: 20) {
                    ForEach(photoAssetIdentifiers, id: \.localIdentifier) { asset in
                        NavigationLink {
                            PhotoView(asset: asset)
                        } label: {
                            PhotoGridItem(asset: asset, geometry: nil)
                        }
                    }
                }
            }
            .padding()
        }
        
        .onDisappear {
            dataController.save()
        }
        .onAppear {
            let assetIdentifiers = step.stepPhotoAssetIdentifiers.compactMap(\.assetIdentifier)
            photoAssetIdentifiers.fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: assetIdentifiers, options: nil)
        }
        .onChange(of: selectedPhoto) { newPhoto in
            Task {
                addPhoto(photo: newPhoto)
                let assetIdentifiers = step.stepPhotoAssetIdentifiers.compactMap(\.assetIdentifier)
                photoAssetIdentifiers.fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: assetIdentifiers, options: nil)
            }
        }
    }
    
    func updateStep() {
        // TODO: - Navigating back to tripView does not refresh view
        step.trip?.objectWillChange.send()
        step.name = name
        step.timestamp = timestamp
    }
    
    func addPhoto(photo: PhotosPickerItem?) {
        if let photoIdentifier = photo?.itemIdentifier {
            let newPhoto = PhotoAssetIdentifier(context: dataController.container.viewContext, assetIdentifier: photoIdentifier)
            step.addToPhotoAssetIdentifiers(newPhoto)
            step.trip?.addToPhotoAssetIdentifiers(newPhoto)
            dataController.save()
        }
    }
}

struct StepView_Previews: PreviewProvider {
    static var previews: some View {
        StepView(step: .preview)
    }
}
