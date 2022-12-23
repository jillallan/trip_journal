//
//  StepAnnotation.swift
//  Trip Journal
//
//  Created by Jill Allan on 23/12/2022.
//

import SwiftUI

struct StepAnnotation: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 24, height: 24)
            Circle()
                .fill(Color.accentColor)
                .frame(width: 16, height: 16)
        }
//        .background(Color.black)
        
    }
}

struct StepAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        StepAnnotation()
    }
}
