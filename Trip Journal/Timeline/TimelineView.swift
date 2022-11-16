//
//  TimelineView.swift
//  Trip Journal
//
//  Created by Jill Allan on 15/11/2022.
//

import SwiftUI

struct TimelineView: View {
    @StateObject var timelineViewModel = TimelineViewModel()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(timelineViewModel.dateRange, id: \.self) { day in
                    Text("\(day, formatter: dateFormatter)")
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


