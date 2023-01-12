//
//  EntryView.swift
//  Trip Journal
//
//  Created by Jill Allan on 01/12/2022.
//

import PhotosUI
import SwiftUI

struct EntryView: View {
    let columns = [
        GridItem(.fixed(200))
    ]
    
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var photoAssetManager: PhotoLibraryService
    @State var photoAssetIdentifiers = PHFetchResultCollection(fetchResult: .init())
    @ObservedObject var entry: Entry
    
    @State private var name: String
    @State private var timestamp: Date

    
    @State private var showingPhotoPicker = false
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedPhotos: [PhotosPickerItem] = []
    
    init(entry: Entry) {
        self.entry = entry
        _name = State(initialValue: entry.entryName)
        _timestamp = State(initialValue: entry.entryTimestamp)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView() {
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 3) {
                    ForEach(photoAssetIdentifiers, id: \.localIdentifier) { asset in
                        NavigationLink(value: asset) {
                            Photo(asset: asset)
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
                DatePicker("Entry Date", selection: $timestamp.onChange(updateEntry))
            }
            .padding(.horizontal)
        }
        
        // MARK: - Navigation
        .navigationDestination(for: PHAsset.self) { asset in
            Photo(asset: asset)
        }
        .navigationTitle($name.onChange(updateEntry))
        .navigationBarTitleDisplayMode(.large)
        
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    delete(entry)
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
            let assetIdentifiers = entry.entryPhotoAssetIdentifiers.compactMap(\.assetIdentifier)
            photoAssetIdentifiers.fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: assetIdentifiers, options: nil)
        }
        
        // TODO: - check this works with multi picker
        .onChange(of: selectedPhotos) { photos in
            for photo in photos {
                Task {
                    addPhoto(photo: photo)
                    let assetIdentifiers = entry.entryPhotoAssetIdentifiers.compactMap(\.assetIdentifier)
                    photoAssetIdentifiers.fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: assetIdentifiers, options: nil)
                }
            }
        }
    }
    
    func updateEntry() {
        // TODO: - create new entry location, delete old location if manually created
        // TODO: - manually created if distance and horizontal accuracy are 0 (and speed -1 ??)
        
        entry.location?.objectWillChange.send()
        entry.name = name
        entry.timestamp = timestamp
    }
    
    func updateEntryTimestamp() {
        // TODO: - create new entry location, delete old location if manually created
        // TODO: - manually created if distance and horizontal accuracy are 0 (and speed -1 ??)
        
        entry.location?.objectWillChange.send()
        entry.timestamp = timestamp
        if entry.location?.distance == 0 {
            // delete location
        }
    }
    
    func addPhoto(photo: PhotosPickerItem?) {
        if let photoIdentifier = photo?.itemIdentifier {
            let newPhoto = PhotoAssetIdentifier(context: dataController.container.viewContext, assetIdentifier: photoIdentifier)
            entry.addToPhotoAssetIdentifiers(newPhoto)
            entry.trip?.addToPhotoAssetIdentifiers(newPhoto)
            dataController.save()
        }
    }
    
    func delete(_ entry: Entry) {
        entry.trip?.objectWillChange.send()
        entry.location?.objectWillChange.send()
        // TODO: - Delete location if manually created
        
        dataController.delete(entry)
        dataController.save()
    }

}

//struct EntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        EntryView(entry: .preview)
//    }
//}
