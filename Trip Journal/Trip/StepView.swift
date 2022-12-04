//
//  StepView.swift
//  Trip Journal
//
//  Created by Jill Allan on 01/12/2022.
//

import PhotosUI
import SwiftUI

struct StepView: View {
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var photoAssetManager: PhotoAssetManager
    @ObservedObject var step: Step
    
    @State private var name: String
    @State private var timestamp: Date
    @State private var photoIdentifier: String
    
    @State private var inputImage: UIImage?
    @State private var showingPhotoPicker = false
    
    init(step: Step) {
        self.step = step
        _name = State(initialValue: step.stepName)
        _timestamp = State(initialValue: step.stepTimestamp)
        _photoIdentifier = State(initialValue: step.stepPhotoIdentifier)
    }
    
    var body: some View {
        Form {
            TextField("Step Name", text: $name.onChange(update))
            DatePicker("Step Date", selection: $timestamp.onChange(update))
            Button("Add Photos") {
                // TODO: - Add photo picker
                showingPhotoPicker = true
            }
            if let inputImage = inputImage {
                Image(uiImage: inputImage)
            }
            
            Image("seamonster")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
        }
        .onDisappear {
            dataController.save()
        }
        .sheet(isPresented: $showingPhotoPicker) {
            PhotoPicker()
        }
        .onAppear {
            let asset = photoAssetManager.fetchAssets().firstObject
            getPhoto(from: asset, size: CGSize(width: 200, height: 200))
        }
    }
    
    func update() {
        // TODO: - Navigating back to tripView does not refresh view
        step.trip?.objectWillChange.send()
        
        step.name = name
        step.timestamp = timestamp
    }
    
    func getPhoto() {
        let assest = photoAssetManager.fetchAssets()
        let asset = assest.firstObject
    }
    
    func getPhoto(from asset: PHAsset?, size: CGSize) {
        
        guard let asset = asset else { return }

        
        let resultHandler: (UIImage?, [AnyHashable: Any]?) -> Void = { image, info in
            self.inputImage = image
        }
        
        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: nil, resultHandler: resultHandler)
    }
}

struct StepView_Previews: PreviewProvider {
    static var previews: some View {
        StepView(step: .preview)
    }
}
