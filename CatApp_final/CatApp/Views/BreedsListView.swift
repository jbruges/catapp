import SwiftUI

import SwiftUI

struct BreedsListView: View {
    @StateObject private var vm = BreedsListViewModel(
        repo: BreedRepository(api: CatAPIClient(apiKey: Secrets.catApiKey))
    )
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                   
                    SearchBar(text: $vm.searchText, placeholder: "Search breeds")
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    if vm.isLoading {
                        ProgressView("Loading...")
                            .padding()
                    } else {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(Array(vm.filteredBreeds), id: \.objectID) { breed in
                                NavigationLink(destination: BreedDetailView(breed: breed)) {
                                    BreedCardView(breed: breed) {
                                        vm.toggleFavorite(breed)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        .padding(.bottom, 16)
                    }
                }
            }
            .navigationTitle("Cat Breeds")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: vm.refreshFromAPI) {
                    Image(systemName: "arrow.clockwise")
                }
            }
            .onAppear {
                vm.fetchLocal()
                vm.refreshFromAPI()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
