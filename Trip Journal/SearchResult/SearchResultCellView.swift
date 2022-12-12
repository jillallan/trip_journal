//
//  SearchResultCellView.swift
//  Trip Journal
//
//  Created by Jill Allan on 14/11/2022.
//

import MapKit
import SwiftUI

struct SearchResultCellView: View {
//    let result: MKMapItem
//    let viewModel: SearchResultCellViewModel
    let result: MKMapItem
    
//    init(result: MKMapItem) {
//        viewModel = SearchResultCellViewModel(result: result)
//    }
    
    var body: some View {
        HStack {
            Image(systemName: result.pointOfInterestCategory?.symbolName ?? "mappin.and.ellipse")
            VStack(alignment: .leading) {
                Text(result.name ?? "N/A")
                    .font(.headline)
                    .foregroundColor(.accentColor)
                Text("\(result.placemark.subThoroughfare ?? "N/A") \(result.placemark.thoroughfare ?? "N/A") \(result.placemark.locality ?? "N/A")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

//struct SearchResultCellView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 51.5, longitude: 0)))
//        SearchResultCellView(result: mapItem)
//    }
//}
