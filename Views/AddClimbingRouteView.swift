import SwiftUI
import PhotosUI

struct AddClimbingRouteView: View {
    @ObservedObject var viewModel: AddClimbingRouteViewModel
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var context
    
    var body: some View {
        NavigationView {
            Form {
                ImagePickerView(
                    imageState: $viewModel.imageState,
                    selectedPickerItem: $viewModel.selectedPickerItem
                )
                RouteEditFieldsView(
                    name: $viewModel.name,
                    difficulty: $viewModel.difficulty,
                    date: $viewModel.date,
                    succeeded: $viewModel.succeeded,
                    flashed: $viewModel.flashed
                )
                NotesView(
                    isEditing: .constant(true),
                    notes: $viewModel.notes
                )
            }
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                viewModel.saveRoute(context: context)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct AddClimbingRouteView_Previews: PreviewProvider {
    static var previews: some View {
        AddClimbingRouteView(viewModel: AddClimbingRouteViewModel())
    }
}

