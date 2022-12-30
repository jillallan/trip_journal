//
//  AddStepDetailView.swift
//  Trip Journal
//
//  Created by Jill Allan on 30/12/2022.
//

import SwiftUI

struct AddStepDetailView: View {
    @EnvironmentObject var dataController: DataController
    let trip: Trip
    let location: Location
    @State var date: Date
    @State var name = "New Step"
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
//                DatePicker("Date", selection: $date)
//                    .padding()
                Button("Add step") {
                    addStep(for: location, name: name, trip: trip, date: date)
                    dismiss()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle($name)
            
        }
        .toolbar {
            Button("Cancel", role: .cancel) {
                dismiss()
            }
        }
    }
    
    func addStep(for location: Location, name: String, trip: Trip, date: Date) {
        
        let step = Step(context: dataController.container.viewContext, coordinate: location.coordinate, timestamp: date, name: name)
        
        step.location = location
        step.trip = trip
        dataController.save()
    }
}

//struct AddStepDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddStepDetailView()
//    }
//}
