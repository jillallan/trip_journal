//
//  StepViewCell.swift
//  Trip Journal
//
//  Created by Jill Allan on 01/12/2022.
//

import SwiftUI
import Photos

struct TripViewStepCell: View {
    let step: Step

    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(step.stepName)
                    .font(.headline)
                    .foregroundColor(.accentColor)
                HStack {
                    Text(step.stepTimestamp, style: .date)
                    Text(step.stepTimestamp, style: .time)
                }
            }
//            Image("seamonster")
        }
    }
    
    func fetchPhoto(for identifier: String) {
        let allPhotosOptions = PHFetchOptions()
        let photo = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: allPhotosOptions)
    }
    
    
}

struct StepViewCell_Previews: PreviewProvider {
    static var previews: some View {
        TripViewStepCell(step: .preview)
    }
}