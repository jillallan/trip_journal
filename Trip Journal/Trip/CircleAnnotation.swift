//
//  CircleAnnotation.swift
//  Trip Journal
//
//  Created by Jill Allan on 23/12/2022.
//

import SwiftUI

struct CircleAnnotation: View {
    var body: some View {
        Circle()
            .fill(Color.purple)
            .frame(width: 12, height: 12)
    }
}

struct CircleAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        CircleAnnotation()
    }
}
