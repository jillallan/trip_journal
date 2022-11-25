//
//  PlacemarksListViewModel.swift
//  Trip Journal
//
//  Created by Jill Allan on 25/11/2022.
//

import CoreLocation
import Foundation

class PlacemarkListView: ObservableObject {
    @Published var placemarks = [CLPlacemark]()
}
