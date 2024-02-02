import SwiftUI
import PhotosUI

import SwiftUI

struct ClimbingRouteDetailView: View {
    @ObservedObject var viewModel: ClimbingRouteViewModel
    @State private var isEditing: Bool = false
    @State private var draftRoute: ClimbingRoute
    
    init(viewModel: ClimbingRouteViewModel) {
        self.viewModel = viewModel
        self._draftRoute = State(initialValue: viewModel.selectedRoute)
    }
    
    var body: some View {
        Form {
            Section {
                if let image = viewModel.selectedRoute.image, !isEditing {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else if isEditing {
                    ImagePickerView(
                        imageState: $viewModel.imageState,
                        selectedPickerItem: $viewModel.selectedPickerItem
                    )
                }
            }
            .frame(height: 200)
            RouteDetailsFieldsView(
                isEditing: $isEditing,
                name: $viewModel.selectedRoute.name,
                difficulty: $viewModel.selectedRoute.difficulty,
                date: $viewModel.selectedRoute.date,
                succeeded: $viewModel.selectedRoute.succeeded,
                flashed: $viewModel.selectedRoute.flashed
            )
            NotesView(
                isEditing: $isEditing,
                notes: $viewModel.selectedRoute.notes
            )
        }
        .navigationBarTitle("Route Details", displayMode: .inline)
        .navigationBarItems(
            trailing: Button(isEditing ? "Done" : "Edit") {
                if isEditing {
                    viewModel.objectWillChange.send()
                    viewModel.updateRoute(updatedRoute: draftRoute)
                } else {
                    draftRoute = viewModel.selectedRoute
                }
                isEditing.toggle()
            }
        )
    }
}

#Preview {
    ClimbingRouteDetailView(viewModel: .init( climbingRoutesData: .init(), climbingRoute: .init(name: "", difficulty: .red, date: .distantPast, succeeded: true, flashed: true, notes: "")))
}
