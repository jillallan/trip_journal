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
            .fill(Color.white)
            .frame(width: 10, height: 10)
    }
}

struct CircleAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        CircleAnnotation()
    }
}
