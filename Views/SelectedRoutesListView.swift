import SwiftUI

struct SelectedRoutesListView: View {
    @ObservedObject var climbingRoutesData: ClimbingRoutesData
    @State var isDeleteAlertPresented = false
    @State private var routeIndexToDelete: Int?
    @State private var searchQuery = ""
    var showOnlySucceeded: Bool
    var startDate: Date
    var endDate: Date
    
    var filteredIndices: [Int] {
        climbingRoutesData.climbingRoutes.enumerated().compactMap { index, route in
            ((showOnlySucceeded ? route.succeeded : true) &&
             DateTimeHelper.isRouteBetween(startDate: startDate, endDate: endDate, climbingRouteDate: route.date)) &&
            searchQuery.isEmpty || route.name.localizedCaseInsensitiveContains(searchQuery) ? index : nil
        }
    }
    
    var body: some View {
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
        .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search Routes")
        .navigationTitle("Selected Routes")
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
    
    private func deleteRoute(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        routeIndexToDelete = index
        isDeleteAlertPresented = true
    }
}
