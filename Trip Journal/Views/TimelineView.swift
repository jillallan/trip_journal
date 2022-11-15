//
//  TimelineView.swift
//  Trip Journal
//
//  Created by Jill Allan on 15/11/2022.
//

import SwiftUI

struct TimelineView: View {

    
    var body: some View {
        NavigationStack {
            List {
    //            ForEach(stride(from: Date(timeIntervalSinceNow: 864000), to: Date.now, by: 86400)) { day in
    //                Text(day)
    //            }
                ForEach(0..<20) { int in
                    Text(int, format: .number)
                }
            }
            .navigationTitle("Trip Journal")
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}
