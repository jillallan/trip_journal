//
//  StepView.swift
//  Trip Journal
//
//  Created by Jill Allan on 01/12/2022.
//

import PhotosUI
import SwiftUI

struct StepView: View {
    enum LoadingState {
        case loading, loaded, failed
    }
    
    let rows = [
        GridItem(.fixed(200))
    ]
    
    @State private var loadingState = LoadingState.loading
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var photoAssetManager: PhotoLibraryService
    @ObservedObject var step: Step
    
    @State private var name: String
    @State private var timestamp: Date
//    @State private var photos: [UIImage]
//    @State private var photoIdentifier: String
    
    @State private var inputImage: UIImage?
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
                
                if let inputImage = inputImage {
                    Image(uiImage: inputImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 400, height: 400)
                }
            }
            ScrollView(.horizontal) {
                LazyHGrid(rows: rows, spacing: 20) {
                    ForEach(0..<3) { int in
                        Image("seamonster")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                    }
                }
            }
            .padding()
        }
        
        .onDisappear {
            dataController.save()
        }
        .sheet(isPresented: $showingPhotoPicker) {
            PhotoPicker()
        }
        .onAppear {
            let assetIdetifiers = step.stepPhotos
            if let asset = photoAssetManager.fetchAssets(with: assetIdetifiers).firstObject {
                getPhoto(from: asset, size: CGSize(width: 400, height: 400))
            }
        }
        .onChange(of: selectedPhoto) { newPhoto in
            Task {
                addPhoto(photo: newPhoto)
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
            let newPhoto = Photo(context: dataController.container.viewContext, assetIdentifier: photoIdentifier)
            step.addToPhotos(newPhoto)
            dataController.save()
        }
    }
    
    func getPhoto(from asset: PHAsset?, size: CGSize) {
        guard let asset = asset else { return }
        
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: size,
            contentMode: .aspectFit,
            options: nil) { image, info in
                self.inputImage = image
            }
    }
    
    func getPhotos() {
        let assetIdetifiers = step.stepPhotos
        let photoIdentifiers = photoAssetManager.fetchAssets(with: assetIdetifiers)
    }
}

struct StepView_Previews: PreviewProvider {
    static var previews: some View {
        StepView(step: .preview)
    }
}
