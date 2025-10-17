# catapp
Cat Breeds App
Overview
Cat Breeds is an iOS app built using SwiftUI, Core Data, and Combine. It displays a list of cat breeds fetched from a remote API and allows users to mark their favorite breeds. The app includes:
●	Browse cat breeds in a grid layout (collection view style).

●	Search breeds by name.

●	View detailed breed information, including origin, temperament, description, and image.

●	Favorite/unfavorite breeds with persistence in Core Data.

●	Compute the average lifespan of favorite breeds.

●	Offline support via Core Data caching.

 
Architecture
 



1. SwiftUI Views
●	BreedsListView – Displays all breeds in a grid with a search bar. Each breed is presented as a card with an image, name, and favorite toggle.

●	BreedDetailView – Shows a breed’s details with the image as the background and the title overlayed. Favorite toggle is represented by a star icon.

●	FavoritesView – Shows the user’s favorite breeds and calculates their average lifespan.

Design choices:
●	Grid layout implemented via LazyVGrid for a responsive collection-style UI.

●	ScrollView wraps the grid for vertical scrolling.

●	Navigation is handled with NavigationView + NavigationLink.

●	Favorites toggle is a star icon for simplicity and UX consistency.

 
2. Core Data
●	Used to persist favorite breeds and cache API results for offline support.

●	BreedEntity stores breed properties like name, origin, temperament, image URL/data, isFavorite, and lifespan.

●	In-memory store is used for unit testing to avoid touching disk.

 
3. API Layer
●	CatAPIClientProtocol defines an interface for fetching breeds.

●	CatAPIClient implements the real API call.

●	MockCatAPIClient used for unit tests to inject predictable data.

Design choice: Protocol-based dependency injection enables testable ViewModels.
 
4. Repository Layer
●	BreedRepository handles API requests and Core Data persistence.

●	Converts Breed models into BreedEntity objects.

●	Manages favorite toggling.

Design choice: Repository pattern isolates networking + persistence logic from ViewModels, simplifying unit testing.
 
5. ViewModels
●	BreedsListViewModel – Manages fetching, searching, and filtering breeds.

●	BreedDetailViewModel – Handles favorite toggling and business logic for the detail view.

●	FavoritesViewModel – Computes favorite breeds and calculates average lifespan.

Design choice: ViewModels are ObservableObject and contain all state and business logic. Views are kept stateless.
 
6. Testing
●	Unit tests cover ViewModel logic only.

●	Dependencies are injected:

○	MockCatAPIClient for network responses.

○	InMemoryCoreDataManager for persistence.

●	Tested functionality:

○	Fetching breeds from API.

○	Filtering and searching.

○	Toggling favorites.

○	Computing average lifespan.

Design choice: Tests are deterministic and isolated, ensuring high reliability.
 
Dependencies
●	SwiftUI

●	Combine

●	Core Data

 
Known Issues / Notes
●	NavigationBar title initially appears too large; shrinks on scroll due to inline display mode.

●	Some system symbols may not exist on older iOS versions (e.g., "pawprint").

●	Grid layout spacing and insets may require adjustments depending on device.

 
Future Improvements
●	Add pull-to-refresh.

●	Improve image caching and async loading.

●	Implement error handling for network failures.

●	Enhance UI/UX with animations and custom transitions.

 
Explanation:
1.	Views (SwiftUI)

○	Only handle layout and presentation.

○	Observe ViewModels for state changes.

2.	ViewModels

○	ObservableObjects that manage business logic.

○	Handle fetching, filtering, favorite toggling, and lifespan calculations.

○	Expose @Published properties for UI updates.

3.	Repository

○	Single source of truth for data.

○	Fetches from API and caches in Core Data.

○	Converts network models into Core Data entities.

4.	API Client

○	Fetches breeds from remote API.

○	Protocol-based for testing.

○	Supports mock client for unit testing.

5.	Core Data

○	Stores BreedEntity objects.

○	Tracks favorites and persists cached data.

 
💡 Notes on Design Choices:
●	Dependency Injection: API clients and repositories are injected into ViewModels to make testing easier.

●	Protocol-Oriented Design: Allows mocking network responses.

●	Separation of Concerns: Views only display data, ViewModels handle logic, Repository handles persistence/network.

●	Unit Testing: Only ViewModel logic is tested, using in-memory Core Data stores. 
<img width="442" height="423" alt="image" src="https://github.com/user-attachments/assets/17e2b0c1-8c7a-4d16-a6a3-0906af6b442f" />
