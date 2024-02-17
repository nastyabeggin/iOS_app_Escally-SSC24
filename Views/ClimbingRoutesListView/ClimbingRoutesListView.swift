import SwiftUI
import SwiftData
import TipKit

struct ClimbingRoutesListView: View {
    @Environment(\.modelContext) var context
    @Query private var routes: [ClimbingRoute]
    
    @State private var showingAddRouteView = false
    @State var isDeleteAlertPresented = false
    @State var selectedSortOption: SortOption = .byDate
    @State private var routeToDelete: ClimbingRoute?
    @State private var searchQuery = ""
    
    private let addRouteTip = AddRouteTip()
    
    private var filteredRoutes: [ClimbingRoute] {
        if searchQuery.isEmpty {
            return routes.sort(on: selectedSortOption)
        }
        let filteredRoutes = routes.compactMap { route in
            let nameContainsQuery = route.name.range(
                of: searchQuery,
                options: .caseInsensitive) != nil
            let difficultyContainsQuery = route.difficulty.rawValue.range(
                of: searchQuery,
                options: .caseInsensitive) != nil
            return (nameContainsQuery || difficultyContainsQuery) ? route : nil
        }
        return filteredRoutes.sort(on: selectedSortOption)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredRoutes, id: \.self) { route in
                    NavigationLink {
                        ClimbingRouteDetailView(
                            viewModel: ClimbingRouteViewModel(climbingRoute: route))
                    } label: {
                        ClimbingRouteRow(route: route)
                            .swipeActions {
                                Button {
                                    isDeleteAlertPresented = true
                                    routeToDelete = route
                                } label: {
                                    Image(systemName: "trash")
                                        .symbolVariant(.fill)
                                }
                                .tint(.red)
                            }
                    }
                }
            }
            .searchable(text: $searchQuery, prompt: "Search Routes")
            .overlay {
                if filteredRoutes.isEmpty && !searchQuery.isEmpty {
                    ContentUnavailableView.search
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    toolbarMenu
                        .popoverTip(addRouteTip)
                }
            }
            .navigationTitle("Climbing Routes")
        }
        .alert(isPresented: $isDeleteAlertPresented) {
            Alert(
                title: Text("Confirm Delete"),
                message: Text("Are you sure you want to delete this route?"),
                primaryButton: .destructive(Text("Delete")) {
                    deleteRoute()
                },
                secondaryButton: .cancel()
            )
        }
        .animation(.default, value: filteredRoutes)
        .sheet(isPresented: $showingAddRouteView) {
            AddClimbingRouteView(viewModel: AddClimbingRouteViewModel())
        }
    }
    
    private var toolbarMenu: some View {
        Menu {
            Menu {
                Picker(selection: $selectedSortOption, label: Text("Sorting options")) {
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
            Image(systemName: "ellipsis.circle")
        }
    }
    
    private func deleteRoute() {
        guard let routeToDelete = routeToDelete else { return }
        context.delete(routeToDelete)
        try? context.save()
        self.routeToDelete = nil
    }
}

private extension [ClimbingRoute] {
    func sort(on option: SortOption) -> [ClimbingRoute] {
        switch option {
        case .byName:
            self.sorted(by: { $0.name < $1.name })
        case .byDate:
            self.sorted(by: { $0.date > $1.date })
        case .byDifficulty:
            self.sorted(by: { $0.difficulty.rawValue < $1.difficulty.rawValue })
        case .bySuccess:
            self.sorted(by: { $0.succeeded && !$1.succeeded })
        }
    }
}

#Preview {
    ClimbingRoutesListView()
        .modelContainer( PreviewContainer([ClimbingRoute.self]).container)
        .task {
            try? Tips.resetDatastore()
            try? Tips.configure([
                .datastoreLocation(.applicationDefault)
            ])
        }
}
