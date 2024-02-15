import SwiftUI
import PhotosUI

struct AddClimbingRouteView: View {
    @ObservedObject var viewModel: AddClimbingRouteViewModel
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var context

    @State private var showingImageEditor = false
    
    var body: some View {
        NavigationView {
            Form {
                ImagePickerView(
                    imageState: $viewModel.imageState,
                    selectedPickerItem: $viewModel.selectedPickerItem
                )
                .onTapGesture {
                    if case .success(let imageData) = viewModel.imageState {
                        showingImageEditor = true
                    }
                }
                RouteEditFieldsView(
                    name: $viewModel.currentClimbingRoute.name,
                    difficulty: $viewModel.currentClimbingRoute.difficulty,
                    date: $viewModel.currentClimbingRoute.date,
                    succeeded: $viewModel.currentClimbingRoute.succeeded,
                    flashed: $viewModel.currentClimbingRoute.flashed
                )
                NotesView(
                    isEditing: .constant(true),
                    notes: $viewModel.currentClimbingRoute.notes
                )
            }
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                viewModel.saveRoute(context: context)
                presentationMode.wrappedValue.dismiss()
            })
        }
        .sheet(isPresented: $showingImageEditor) {
            if case .success(let imageData) = viewModel.imageState {
                ImageEditingView(climbingRoute: $viewModel.currentClimbingRoute, imageData: .constant(imageData))
            }
        }
    }
}

struct AddClimbingRouteView_Previews: PreviewProvider {
    static var previews: some View {
        AddClimbingRouteView(viewModel: AddClimbingRouteViewModel())
    }
}

