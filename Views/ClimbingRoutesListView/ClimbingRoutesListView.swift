import SwiftUI

struct ClimbingRoutesListView: View {
    @StateObject var climbingRoutesData = ClimbingRoutesData()
    @State private var showingAddRouteView = false
    @State var isDeleteAlertPresented = false
    @State private var routeIndexToDelete: Int?
    
    var body: some View {
        NavigationView {
            List {
                ForEach($climbingRoutesData.climbingRoutes, id: \.self) { route in
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
            .toolbar {
                Button(action: {
                    showingAddRouteView.toggle()
                }) {
                    Image(systemName: "plus")
                }
            }
            .navigationTitle("Climbing Routes")
        }
        .sheet(isPresented: $showingAddRouteView) {
            AddClimbingRouteView(viewModel: .init(climbingRoutesData: climbingRoutesData))
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
    
    private func deleteRoute(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        routeIndexToDelete = index
        isDeleteAlertPresented = true
    }
}

#Preview {
    ClimbingRoutesListView(climbingRoutesData: .init())
}
