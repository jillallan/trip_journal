//
//  StepsView.swift
//  Trip Journal
//
//  Created by Jill Allan on 28/12/2022.
//

import SwiftUI

struct StepsView: View {
    @EnvironmentObject var dataController: DataController
    @FetchRequest(
        entity: Step.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Step.timestamp, ascending: true)]
    ) var steps: FetchedResults<Step>
    
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    Text("Step Count")
                    Text(steps.count, format: .number)
                }
                ForEach(steps) { step in
                    VStack {
                        HStack {
                            Text(step.stepTimestamp, style: .date)
                            Text(step.stepTimestamp, style: .time)
                            Text(step.latitude, format: .number)
                            Text(step.longitude, format: .number)
                        }
                        HStack {
                            Text("Distance")
                            Text(step.distance, format: .number)
                            Text("Horizontal Accuracy")
                            Text(step.horizontalAccuracy, format: .number)
                            Text("Speed")
                            Text(step.speed, format: .number)
                            Text("Calc Speed")
                            Text(step.calculatedSpeed, format: .number)
                        }
                        HStack {
                            Text(step.entry?.entryName ?? "No entry")
                        }
                    }
                    .font(.caption)
                }
            }
            .navigationTitle("Steps")
        }
    }
}

struct StepsView_Previews: PreviewProvider {
    static var previews: some View {
        StepsView()
    }
}
