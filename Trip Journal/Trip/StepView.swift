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
        }
        .onDisappear {
            dataController.save()
        }
        .sheet(isPresented: $showingPhotoPicker) {
            PhotoPicker(image: $inputImage)
        }
    }
    
    func update() {
        // TODO: - Navigating back to tripView does not refresh view
        step.trip?.objectWillChange.send()
        
        step.name = name
        step.timestamp = timestamp
    }
}

struct StepView_Previews: PreviewProvider {
    static var previews: some View {
        StepView(step: .preview)
    }
}
