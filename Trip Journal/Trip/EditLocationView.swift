//
//  LocationView.swift
//  Trip Journal
//
//  Created by Jill Allan on 21/12/2022.
//

import SwiftUI

struct EditLocationView: View {
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.dismiss) var dismiss
    @FetchRequest var locations: FetchedResults<Location>
    
    init(location: Location) {
        _locations = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Location.timestamp, ascending: true)],
            predicate: NSPredicate(format: "id > %@", location.locationId as CVarArg)
        )
    }
    
    var body: some View {
        if let location = locations.first {
            Text("Lat: \(location.latitude), Lon: \(location.longitude), timestamp: \(location.locationTimestamp)")
            Button {
                delete(location)
                dismiss()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    func delete(_ location: Location) {
        if let step = location.step {
            dataController.delete(step)
        }
        dataController.delete(location)
        dataController.save()
    }
    
}
//
//struct LocationView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditLocationView(id: UUID())
//    }
//}
