//
//  Trip2View.swift
//  Trip Journal
//
//  Created by Jill Allan on 10/12/2022.
//

import CoreData
import MapKit
import SwiftUI

struct TripView: View {

    let trip: Trip
    
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var locationManager: LocationManager
    
    @State var region: MKCoordinateRegion
//    @State var coord: CLLocationCoordinate2D
    @State var span: MKCoordinateSpan
    
    @FetchRequest var steps: FetchedResults<Step>
    
    @State var currentlyDisplayedSteps: [Step] = []
    
    init(trip: Trip) {
        self.trip = trip
//        let coord = trip.region.center
        let span = trip.region.span
        let region = trip.region

        _steps = FetchRequest<Step>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Step.timestamp, ascending: true)],
            predicate: NSPredicate(format: "trip.title = %@", trip.tripTitle)
        )
        
//        _coord = State(initialValue: coord)
        _span = State(initialValue: span)
        _region = State(initialValue: region)

    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                VStack {
                    VStack {
                        Text("\(region.center.longitude)")
//                        Text("\(coord.longitude)")

//                        Map(coordinateRegion: $region)
                        
                    }
                    .frame(height: geo.size.height * 0.7)
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: [GridItem()]) {
                            ForEach(steps) { step in
                                NavigationLink {
                                    StepView(step: step)
                                } label: {
                                    StepCard(step: step, geometry: geo)
                                        .cornerRadius(12)
                                        .clipped(antialiased: true)
                                }
                                .onAppear {
                                    
                                    let centre = step.coordinate
                                    
                                    span.latitudeDelta += 0.000000001
                                    //                                        region = step.region
                                    region = MKCoordinateRegion(center: centre, span: span)
                                }
//                                .onDisappear {
//                                    let
//                                }
                            }
                        }
                    }
                    .frame(height: geo.size.height * 0.3)
                }
            }
            .navigationTitle("Test")
        }
    }
    

}

struct Trip2View_Previews: PreviewProvider {
    static var previews: some View {
        Trip2View(trip: .preview)
    }
}
