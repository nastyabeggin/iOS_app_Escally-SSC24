import SwiftUI
import SwiftData

struct SelectedRoutesListView: View {
    @Environment(\.modelContext) var context
    @Query private var routes: [ClimbingRoute]

    @State var isDeleteAlertPresented = false
    @State private var searchQuery = ""
    @State private var routeToDelete: ClimbingRoute?
    
    var showOnlySucceeded: Bool
    var startDate: Date
    var endDate: Date
    
    private var filteredRoutes: [ClimbingRoute] {
        routes.filter { route in
            let matchesSucceededFilter = showOnlySucceeded ? route.succeeded : true
            let matchesDateRange = route.date.isBetween(startDate: startDate, endDate: endDate)
            let nameContainsQuery = route.name.range(
                of: searchQuery,
                options: .caseInsensitive) != nil
            let difficultyContainsQuery = route.difficulty.rawValue.range(
                of: searchQuery,
                options: .caseInsensitive) != nil
            let matchesSearchQuery = searchQuery.isEmpty || nameContainsQuery || difficultyContainsQuery
            
            return matchesSucceededFilter && matchesDateRange && matchesSearchQuery
        }
    }

    
    var body: some View {
        List {
            ForEach(filteredRoutes, id: \.self) { route in
                NavigationLink {
                    ClimbingRouteDetailView(
                        viewModel: ClimbingRouteViewModel(climbingRoute: route)
                    )} label: {
                        ClimbingRouteRow(route: route)
                            .swipeActions {
                                Button {
                                    isDeleteAlertPresented = true
                                    routeToDelete = route
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                        .symbolVariant(.fill)
                                }
                                .tint(.red)
                            }
                    }
            }
        }
        .animation(.default, value: filteredRoutes)
        .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search Routes")
        .overlay {
            if filteredRoutes.isEmpty && !searchQuery.isEmpty {
                ContentUnavailableView.search
            }
        }
        .navigationTitle("Selected Routes")
        .alert(isPresented: $isDeleteAlertPresented) {
            Alert(
                title: Text("Confirm Delete"),
                message: Text("Are you sure you want to delete this note?"),
                primaryButton: .destructive(Text("Delete")) {
                    deleteRoute()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func deleteRoute() {
        guard let routeToDelete = routeToDelete else { return }
        context.delete(routeToDelete)
        try? context.save()
        self.routeToDelete = nil
    }
}
