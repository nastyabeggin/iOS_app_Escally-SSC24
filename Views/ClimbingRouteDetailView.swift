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
                Group {
                    if let image = viewModel.selectedRoute.image, !isEditing {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else if viewModel.selectedRoute.image == nil && !isEditing {
                        ImagePickerView(
                            imageState: $viewModel.imageState,
                            selectedPickerItem: $viewModel.selectedPickerItem
                        ).onChange(of: viewModel.selectedPickerItem) {
                            saveUpdatedRoute()
                        }
                    } else if isEditing {
                        ImagePickerView(
                            imageState: $viewModel.imageState,
                            selectedPickerItem: $viewModel.selectedPickerItem
                        )
                    }
                }
                .transition(.opacity)
                .animation(.default, value: isEditing)
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
            .transition(.slide)
            .animation(.default, value: isEditing)
            NotesView(
                isEditing: $isEditing,
                notes: $viewModel.selectedRoute.notes
            )
            .transition(.slide)
            .animation(.default, value: isEditing)
        }
        .navigationBarTitle("Route Details", displayMode: .inline)
        .navigationBarItems(
            trailing: Button(isEditing ? "Done" : "Edit") {
                withAnimation {
                    if isEditing {
                        saveUpdatedRoute()
                    } else {
                        draftRoute = viewModel.selectedRoute
                    }
                    isEditing.toggle()
                }
            }
        )
    }
    
    private func saveUpdatedRoute() {
        if case .success(let image) = viewModel.imageState {
            draftRoute.image = image
        } else {
            draftRoute.image = nil
        }
        viewModel.objectWillChange.send()
    }
}

#Preview {
    ClimbingRouteDetailView(viewModel: .init( climbingRoutesData: .init(), climbingRoute: .init(name: "", difficulty: .red, date: .distantPast, succeeded: true, flashed: true, notes: "")))
}
