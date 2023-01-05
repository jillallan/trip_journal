//
//  AddStepDetailView.swift
//  Trip Journal
//
//  Created by Jill Allan on 30/12/2022.
//

import MapKit
import SwiftUI
import PhotosUI

struct AddStepDetailView: View {
    
    // MARK: - View Properties
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var locationManager: LocationManager
    
    @Environment(\.dismiss) var dismiss
    @State var photoAssets = PHFetchResultCollection(fetchResult: .init())
    @State var region: MKCoordinateRegion
    let columns = [
        GridItem(spacing: 3),
        GridItem(spacing: 3)
    ]
    
    // MARK: - Photo Picker Properties
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State var selectedPhotosIdentifiers: [String] = []
    
    // MARK: - Step Properties
    let trip: Trip
    @State var location: Location? = nil
    @State var clLocation: CLLocation? = nil
    @State var date: Date
    @State var name: String
    @State var onStepAddition: (() -> ())?
    
    // MARK: - Init
    
    init(trip: Trip, location: Location, date: Date, name: String) {
        self.trip = trip
        _location = State(initialValue: location)
        _date = State(initialValue: date)
        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        _region = State(initialValue: region)
        _name = State(initialValue: name)
    }
    
    init(trip: Trip, clLocation: CLLocation, date: Date, name: String, onStepAddition: (() -> ())? = nil) {
        self.trip = trip
        _clLocation = State(initialValue: clLocation)
        let region = MKCoordinateRegion(center: clLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        _date = State(initialValue: date)
        _region = State(initialValue: region)
        _name = State(initialValue: name)
        _onStepAddition = State(initialValue: onStepAddition)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // TODO: - Add annotation item
                Map(coordinateRegion: $region)
                DatePicker("Date", selection: $date)
                    .padding(.horizontal)
                ScrollView() {
                    LazyVGrid(columns: columns, spacing: 3) {
                        ForEach(photoAssets, id: \.localIdentifier) { asset in
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
                        .photoGridItemStyle(aspectRatio: 1.0, cornerRadius: 0)
                        .border(.gray, width: 3)
                    }
                }
                Spacer()
        
                HStack {
                    Spacer()
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                    Spacer()
                    Button("Add step") {
                        if let location = location {
                            addStep(for: location, name: name, trip: trip, date: date, localIdentifiers: selectedPhotosIdentifiers)
                        }
                        if let clLocation = clLocation {
                            // TODO: - Calculate distance and speed based on previous and next location
                       
                            addStep(for: clLocation, name: name, trip: trip, date: date, localIdentifiers: selectedPhotosIdentifiers)
                        }
                        if let onStepAddition = onStepAddition {
                            onStepAddition()
                        }
                        
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    Spacer()
                }
                
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle($name)
        }
        
        .onChange(of: selectedPhotos) { photos in
            Task {
                selectedPhotosIdentifiers.append(contentsOf: photos.compactMap(\.itemIdentifier))
                photoAssets.fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: selectedPhotosIdentifiers, options: nil)
            }
        }
    }
    
    func addStep(for location: Location, name: String, trip: Trip, date: Date, localIdentifiers: [String]) {
        
        let step = Step(context: dataController.container.viewContext, coordinate: location.coordinate, timestamp: date, name: name)
        
        let photoAssetIdentifiers = localIdentifiers.map { localIdentifier in
            PhotoAssetIdentifier(context: dataController.container.viewContext, assetIdentifier: localIdentifier)
        }
        
        step.location = location
        step.trip = trip
        step.photoAssetIdentifiers = Set(photoAssetIdentifiers) as NSSet
        
        dataController.save()
    }
    
    func addStep(for clLocation: CLLocation, name: String, trip: Trip, date: Date, localIdentifiers: [String]) {
        let location = Location(context: dataController.container.viewContext, cLlocation: clLocation, timestamp: date)
        
        let step = Step(context: dataController.container.viewContext, coordinate: location.coordinate, timestamp: date, name: name)
        
        let photoAssetIdentifiers = localIdentifiers.map { localIdentifier in
            PhotoAssetIdentifier(context: dataController.container.viewContext, assetIdentifier: localIdentifier)
        }
        
        step.location = location
        step.trip = trip
        step.photoAssetIdentifiers = Set(photoAssetIdentifiers) as NSSet
        
        dataController.save()
    }
}

//struct AddStepDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddStepDetailView()
//    }
//}
