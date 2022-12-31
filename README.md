# trip_journal
#### Video Demo:  https://youtu.be/iVdkLN10dy8
#### Description:  A swiftui app to record trips using locations and photos
  
This is a ios app to track a users trip, e.g. a holiday/vacation.  The app automtically logs a trip using ios location services.
The user can then use the location automatically logged to add extra details, mainly photos, to create a step.  The user can also add a step manually by either searching for a location or selecting a location on the map.  As the user scrolls through the steps the map overview will change region to focus on the step.

## Files

Trip_JournalApp: Entry point of the app
ContentView: Visual entry point of the app
Main.xcdatamodeld: Core Data Model
Trip-Journal-Info: Configuration

**Extensions**

MKMapItem-Identifiable: Extension to conform to identifiable protocol for use in ForEach SwiftUI view
CLPlacemark-Identifiable: Extension to conform to identifiable protocol for use in ForEach SwiftUI view
Location-CoreDataHelpers: Extension to create convienience initializers and deal with optionals in the NSManagedObjectContext models
Step-CoreDataHelpers: Extension to create convienience initializers and deal with optionals in the NSManagedObjectContext models
Trip-CoreDataHelpers: Extension to create convienience initializers and deal with optionals in the NSManagedObjectContext models
PhotoAssetIdentifier-CoreDataHelpers: Extension to create convienience initializers and deal with optionals in the NSManagedObjectContext models
Array-RemoveDuplicates: Extension to remove duplicates from arrays
MKPointOfInterestCategory-Symbols: Extension to assign a visual symbol to location types
Binding-OnChange: Extension to create an onchange function to swiftui bindings
View-CustomModifiers: Extension for custom view modifiers

**Services**

DataController: Creates a managed object context to save data to core data
LocationManager: Manages location updates to track trips
SearchQuery: Gets results for searchs of new steps to add
PhotoLibraryService: Handles cahcing and fetching photo assets from the user photo library

**Photos**

PhotoGridView: View to show all photos from all trips
JournalImage: Asychronasly loads as photo from a photoAsset
UnwrappedImage: Unwraps an image from a swift optional or gets a background colour and applies a gradient

**Trips**

TripsView: Shows a grid scroll view of all trips
TripCard: A card to show a photo in the trips view grid
TripCardOverlay: Text overlay for the TripCard with name, date and meta data of the trip
AddTripView: View to add a trip

**Trip**

TripView: Show a map with the route of the trip and a scrollview for all the key steps
TripTitleCard: A card to show a photo at the start of the step view grid
TripTitleCardOverlay: Text overlay for the TripTitleCard with name and date of the trip

**Step**

StepCard: A card to show a photo in the steps view grid
TripCardOverlay: Text overlay for the StepCard with name, date and meta data of the step
AddStepView: View to add a step
AddStepDetailView: View to confirm details of the step to add
StepView: Shows a grid scroll view of all the photos in the step

**SearchResult**

SearchResultCellView: Cell in the list of search results, with details of a search result
SearchResultMapView: Map showing the selected search result

**Annotations**

CircleAnnotation: Annotation for the location logged to the locationManager
StepLocation: Annotation for added steps
FeatureAnnotationCardView: View to confirm step added by selecting a map annotation

**UIKitViews**

MapView: UIKit implemtnetion of mapkit, intergrated into swiftui.  Used to display a map, annotations of trip steps and a route overlay of the trip on the map

## Design choices
  
I choose SwiftUI as i found it more modern and pleasurable to use despite it being quite new and therefore not developed quite as much
  
I started off using the MVVM (Model view view model) pattern, but found it cumbersome to use with swiftUI, especially when using core data, as the built in @FetchRequest for use only in swiftUI views is much much more concise.  When using MVVM you cannot use @FetchRequest in a normal swift file.  I refactored the project to use the VM (View Model) design pattern after finding integrating MVVM and SwiftUI so cumbersome and after doing online research.
  
For tracking the user location I used significant location updates to save battery life, but also give enough detail.  The normal location service used too much battery and did not relaunch the app if it was terminated.  And the visit service only logged locations where the user had stayed for a significant amount of time, not locations the user travelled 
  
## TODO

- Bug fixes
- Refactor the app to better adhere to SOLID principles
- Add tests
- Improve the UI and UX

- Give more accurate routes by creating a MKRoute between steps
- Photo suggestions for steps
- Look up landmark information from Wikipedia 
- Integrate with icloud
- Widgets
- Lock screen live activities for current place
- When adding step between existing steps lookup placemark for all added locations to choose from

