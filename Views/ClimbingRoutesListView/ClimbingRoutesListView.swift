import SwiftUI

struct ClimbingRoutesListView: View {
    @StateObject var climbingRoutesData = ClimbingRoutesData()
    @State private var showingAddRouteView = false
    @State var isDeleteAlertPresented = false
    @State private var routeIndexToDelete: Int?
    @State private var searchQuery = ""
    
    var filteredIndices: [Int] {
        climbingRoutesData.sortedRoutes.enumerated().compactMap { index, route in
            searchQuery.isEmpty || route.name.localizedCaseInsensitiveContains(searchQuery) ? index : nil
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredIndices, id: \.self) { index in
                    let route = $climbingRoutesData.sortedRoutes[index]
                    NavigationLink {
                        ClimbingRouteDetailView(
                            viewModel: ClimbingRouteViewModel(
                                climbingRoutesData: climbingRoutesData,
                                climbingRoute: route)
                        )} label: {
                            ClimbingRouteRow(route: route)
                        }
                }
                .onDelete(perform: deleteRoute)
            }
            .searchable(text: $searchQuery, prompt: "Search Routes")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    toolbarMenu
                }
            }
            .navigationTitle("Climbing Routes")
        }
        .sheet(isPresented: $showingAddRouteView) {
            AddClimbingRouteView(viewModel: AddClimbingRouteViewModel(climbingRoutesData: climbingRoutesData))
        }
        .alert(isPresented: $isDeleteAlertPresented) {
            Alert(
                title: Text("Confirm Delete"),
                message: Text("Are you sure you want to delete this note?"),
                primaryButton: .destructive(Text("Delete")) {
                    withAnimation {
                        guard let index = routeIndexToDelete else { return }
                        climbingRoutesData.climbingRoutes.remove(at: index)
                        isDeleteAlertPresented = false
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private var toolbarMenu: some View {
        Menu {
            Menu {
                Picker(selection: $climbingRoutesData.selectedSortOption, label: Text("Sorting options")) {
                    Text("Date").tag(SortOption.byDate)
                    Text("Name").tag(SortOption.byName)
                    Text("Difficulty").tag(SortOption.byDifficulty)
                    Text("Succeeded").tag(SortOption.bySuccess)
                }
            }
        label: {
            Label("Sort", systemImage: "arrow.up.arrow.down")
        }
            Button(action: { showingAddRouteView.toggle() }) {
                Label("Add Route", systemImage: "plus")
            }
        } label: {
            Label("Options", systemImage: "ellipsis.circle")
        }
    }
    
    private func deleteRoute(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        routeIndexToDelete = index
        isDeleteAlertPresented = true
    }
}

#Preview {
    ClimbingRoutesListView(climbingRoutesData: .init())
}
