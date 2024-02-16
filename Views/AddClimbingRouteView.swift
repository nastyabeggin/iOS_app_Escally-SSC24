import SwiftUI
import PhotosUI
import TipKit
import SwiftData

struct AddClimbingRouteView: View {
    @ObservedObject var viewModel: AddClimbingRouteViewModel
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var context

    @State private var showingImageEditor = false
    
    private let addImageTip = AddImageTip()
    
    var body: some View {
        NavigationView {
            Form {
                ImagePickerView(
                    imageState: $viewModel.imageState,
                    selectedPickerItem: $viewModel.selectedPickerItem,
                    showingImageEditor: $showingImageEditor
                )
                .onTapGesture {
                    showingImageEditor = true
                }
                .popoverTip(addImageTip)
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

#Preview {
    AddClimbingRouteView(viewModel: AddClimbingRouteViewModel())
        .modelContainer(PreviewContainer([ClimbingRoute.self]).container)
        .task {
            try? Tips.resetDatastore()
            try? Tips.configure([
                .datastoreLocation(.applicationDefault)
            ])
        }
}
