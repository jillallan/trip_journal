//
//  MKPointOfInterestCategory-Symbols.swift
//  Trip Journal
//
//  Created by Jill Allan on 22/11/2022.
//

import Foundation
import MapKit

extension MKPointOfInterestCategory {
    var symbolName: String {
        switch self {
        case .airport:
            return "airplane"
        case .atm, .bank:
            return "banknote"
        case .bakery, .brewery, .cafe, .restaurant, .winery:
            return "fork.knife"
        case .campground, .hotel:
            return "bed.double"
        case .carRental, .evCharger, .gasStation, .parking:
            return "car"
        case .foodMarket:
            return "cart.circle.fill"
        case .laundry, .store:
            return "tshirt"
        case .library, .museum, .school, .theater, .university:
            return "building.columns"
        case .nationalPark, .park:
            return "leaf"
        case .postOffice:
            return "envelope"
        case .publicTransport:
            return "bus"
        default:
            return "mappin.and.ellipse"
        }
    }
}
