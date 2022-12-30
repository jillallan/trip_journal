# trip_journal
#### Video Demo:  <URL HERE>
#### Description: A swiftui app to record trips using locations and photos

Your README.md file should be minimally multiple paragraphs in length, 
and should explain what your project is, what each of the files you wrote for the project contains and does, 
and if you debated certain design choices, explaining why you made them. 
Ensure you allocate sufficient time and energy to writing a README.md that documents your project thoroughly. 
Be proud of it! If it is too short, the system will reject it.

Files:

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








