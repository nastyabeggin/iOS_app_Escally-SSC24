import SwiftUI
import SwiftData
import TipKit

struct ClimbingRoutesListView: View {
    @Environment(\.modelContext) private var context
    @Query private var routes: [ClimbingRoute]

    @State private var isDeleteAlertPresented = false
    @State private var selectedSortOption: SortOption = .byDate
    @State private var showingAddRouteView = false
    @State private var routeToDelete: ClimbingRoute?
    @State private var searchQuery = ""

    private let addRouteTip = AddRouteTip()

    private var filteredRoutes: [ClimbingRoute] {
        let filtered = routes.filter {
            searchQuery.isEmpty ||
            $0.name.localizedCaseInsensitiveContains(searchQuery) ||
            $0.difficulty.rawValue.localizedCaseInsensitiveContains(searchQuery)
        }
        return filtered.sort(on: selectedSortOption)
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
            .overlay {
                if filteredRoutes.isEmpty && !searchQuery.isEmpty {
                    ContentUnavailableView.search
                } else if filteredRoutes.isEmpty {
                    NoRoutesView()
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
        .searchable(text: $searchQuery, prompt: "Search by name/difficulty")
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
            Picker("Sorting options", selection: $selectedSortOption) {
                Text("Date").tag(SortOption.byDate)
                Text("Name").tag(SortOption.byName)
                Text("Difficulty").tag(SortOption.byDifficulty)
                Text("Succeeded").tag(SortOption.bySuccess)
            }
            Button(action: { showingAddRouteView.toggle() }) {
                Label("Add Route", systemImage: "plus")
            }
        } label: {
            Label("More options", systemImage: "ellipsis.circle")
        }
    }

    private func deleteRoute() {
        guard let routeToDelete else { return }
        context.delete(routeToDelete)
        try? context.save()
        self.routeToDelete = nil
    }
}

private extension [ClimbingRoute] {
    func sort(on option: SortOption) -> [ClimbingRoute] {
        switch option {
        case .byName:
            return sorted(by: { $0.name < $1.name })
        case .byDate:
            return sorted(by: { $0.date > $1.date })
        case .byDifficulty:
            return sorted(by: { $0.difficulty < $1.difficulty })
        case .bySuccess:
            return sorted(by: { $0.succeeded && !$1.succeeded })
        }
    }
}

#Preview {
    ClimbingRoutesListView()
        .modelContainer(PreviewContainer([ClimbingRoute.self]).container)
        .task {
            try? Tips.resetDatastore()
            try? Tips.configure([
                .datastoreLocation(.applicationDefault)
            ])
        }
}
