//
//  DebugView.swift
//  Trip Journal
//
//  Created by Jill Allan on 27/12/2022.
//

import SwiftUI

struct DebugView: View {
    @EnvironmentObject var dataController: DataController
    @FetchRequest(
        entity: EventLog.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \EventLog.timestamp, ascending: false)]
    ) var events: FetchedResults<EventLog>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(events) { event in
                    HStack {
                        Text(event.eventLogTimestamp, style: .date)
                        Text(event.eventLogTimestamp, style: .time)
                        Text(event.eventLogDetail)
                    }
                    .font(.caption)
                }
            }
            .navigationTitle("Log")
        }
    
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView()
    }
}
