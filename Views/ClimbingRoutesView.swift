import SwiftUI

struct ClimbingRoutesView: View {
    @State var climbingRoutesData: ClimbingRoutesData
    @State private var showingAddRouteView = false
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(climbingRoutesData.climbingRoutes) { route in
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
        } detail: {
            Text("Select a Route")
        }
        .sheet(isPresented: $showingAddRouteView) {
            AddClimbingRouteView(viewModel: .init(climbingRoutesData: climbingRoutesData))
        }
    }
    
    private func deleteRoute(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        climbingRoutesData.climbingRoutes.remove(at: index)
    }
}

#Preview {
    ClimbingRoutesView(climbingRoutesData: .init())
}
