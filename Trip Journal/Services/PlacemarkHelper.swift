//
//  PlacemarkHelper.swift
//  Trip Journal
//
//  Created by Jill Allan on 21/11/2022.
//

import Contacts
import CoreLocation
import Foundation

struct PlacemarkHelper {
    func createAddress(from placemark: CLPlacemark) -> [String: Any] {
        var streetKey = ""
        var cityKey = ""
        var postcodeKey = ""
        var countryCodeKey = ""

        if let name = placemark.name,
           let number = placemark.subThoroughfare,
           let street = placemark.thoroughfare {
            streetKey = "\(name), \(number), \(street)"
        } else if let name = placemark.name,
                  let street = placemark.thoroughfare {
            streetKey = "\(name), \(street)"
        } else if let number = placemark.subThoroughfare,
                  let street = placemark.thoroughfare {
            streetKey = "\(number), \(street)"
        } else if let street = placemark.thoroughfare {
            streetKey = "\(street)"
        }

        if let city = placemark.locality {
            cityKey = city
        }
        
        if let city = placemark.postalCode {
            postcodeKey = city
        }
        
        if let countryCode = placemark.isoCountryCode {
            countryCodeKey = countryCode
        }
        
        let address = [
            CNPostalAddressStreetKey: streetKey,
            CNPostalAddressCityKey: cityKey,
            CNPostalAddressPostalCodeKey: postcodeKey,
            CNPostalAddressISOCountryCodeKey: countryCodeKey
        ]
        
        return address
    }
    
    func createPlaceList(from placemarks: [CLPlacemark]) -> [String] {
        var placeList = [String]()
        
        let _ = placemarks.map { placemark in
            if let name = placemark.name,
               let city = placemark.locality {
                placeList.append("\(name), \(city)")
            }
        }
        
        let _ = placemarks.map { placemark in
            if let name = placemark.name,
               let state = placemark.administrativeArea {
                placeList.append("\(name), \(state)")
            }
        }
        
        let _ = placemarks.map { placemark in
            if let areasOfInterest = placemark.areasOfInterest,
               let city = placemark.locality {
                let _ = areasOfInterest.map { areaOfInterest in
                    placeList.append("\(areaOfInterest), \(city)")
                }
            }
        }
        
        let _ = placemarks.map { placemark in
            if let areasOfInterest = placemark.areasOfInterest,
               let state = placemark.administrativeArea {
                let _ = areasOfInterest.map { areaOfInterest in
                    placeList.append("\(areaOfInterest), \(state)")
                }
            }
        }
        
        let _ = placemarks.map { placemark in
            if let areasOfInterest = placemark.areasOfInterest,
               let street = placemark.thoroughfare,
               let city = placemark.locality,
               let state = placemark.administrativeArea {
                let _ = areasOfInterest.map { areaOfInterest in
                    placeList.append("\(areaOfInterest), \(street), \(city), \(state)")
                }
            } else if let areasOfInterest = placemark.areasOfInterest,
                      let city = placemark.locality,
                      let state = placemark.administrativeArea {
                let _ = areasOfInterest.map { areaOfInterest in
                    placeList.append("\(areaOfInterest), \(city), \(state)")
                }
            }
        }
        
        let _ = placemarks.map { placemark in
            if let name = placemark.name,
               let street = placemark.thoroughfare,
               let city = placemark.locality,
               let state = placemark.administrativeArea {
                placeList.append("\(name), \(street), \(city), \(state)")
            } else if let name = placemark.name,
                      let city = placemark.locality,
                      let state = placemark.administrativeArea {
                placeList.append("\(name), \(city), \(state)")
            }
        }
        
        let _ = placemarks.map { placemark in
            if let streetNumber = placemark.subThoroughfare,
               let street = placemark.thoroughfare,
               let city = placemark.locality,
               let state = placemark.administrativeArea {
                placeList.append("\(streetNumber), \(street), \(city), \(state)")
            } else if let city = placemark.locality,
                      let state = placemark.administrativeArea {
                placeList.append("\(city), \(state)")
            } else if let state = placemark.administrativeArea {
                placeList.append("\(state)")
            } else {
                placeList.append("Unknown address")
            }
        }
        
        placeList.removeDuplicates()
//        placeListUnique = placeList.removingDuplicates()
        
        return placeList    }
}


//    print("subThoroughfare: \(String(describing: placemark?.subThoroughfare))")
//    print("administrativeArea: \(String(describing: placemark?.administrativeArea))")
//    print("areasOfInterest: \(String(describing: placemark?.areasOfInterest))")
//    print("country: \(String(describing: placemark?.country))")
//    print("inlandWater: \(String(describing: placemark?.inlandWater))")
//    print("isoCountryCode: \(String(describing: placemark?.isoCountryCode))")
//    print("locality: \(String(describing: placemark?.locality))")
//    print("subLocality: \(String(describing: placemark?.subLocality))")
//    print("name: \(String(describing: placemark?.name))")
//    print("ocean: \(String(describing: placemark?.ocean))")
//    print("postalCode: \(String(describing: placemark?.postalCode))")
//    print("subAdministrativeArea: \(String(describing: placemark?.subAdministrativeArea))")
//    print("thoroughfare: \(String(describing: placemark?.thoroughfare))")

