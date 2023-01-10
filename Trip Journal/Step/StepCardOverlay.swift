//
//  StepCardOverlay.swift
//  Trip Journal
//
//  Created by Jill Allan on 19/12/2022.
//

import SwiftUI

struct StepCardOverlay: View {
    let step: Step
    
    var body: some View {
        VStack() {
            VStack() {
                Text(step.stepName)
                    .font(.headline)
//                    .multilineTextAlignment(.leading)
                Text(step.stepTimestamp.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline)
            }
            Spacer()
            HStack {
                metricsLabel(count: step.stepPhotoAssetIdentifiers.count, units: "photos", systemImage: "photo.on.rectangle.angled")
            }
        }
        .padding()
        .foregroundColor(.white)
    }
}

//struct StepCardOverlay_Previews: PreviewProvider {
//    static var previews: some View {
//        StepCardOverlay(step: .preview)
//    }
//}
