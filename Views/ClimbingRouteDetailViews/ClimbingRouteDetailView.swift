import SwiftUI
import PhotosUI

struct ClimbingRouteDetailView: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var viewModel: ClimbingRouteViewModel
    @State private var isEditing: Bool = false
    @State private var showingImageEditor = false

    var body: some View {
        Form {
            Section {
                RouteImageView(
                    isEditing: $isEditing,
                    imageState: $viewModel.imageState,
                    selectedPickerItem: $viewModel.selectedPickerItem,
                    imageData: viewModel.selectedRoute.image
                )
                .onTapGesture {
                    showingImageEditor = true
                }
            }
            Group {
                if isEditing {
                    RouteEditFieldsView(
                        name: $viewModel.draftRoute.name,
                        difficulty: $viewModel.draftRoute.difficulty,
                        date: $viewModel.draftRoute.date,
                        succeeded: $viewModel.draftRoute.succeeded,
                        flashed: $viewModel.draftRoute.flashed
                    )
                } else {
                    RouteDetailsFieldsView(
                        name: $viewModel.selectedRoute.name,
                        difficulty: $viewModel.selectedRoute.difficulty,
                        date: $viewModel.selectedRoute.date,
                        succeeded: $viewModel.selectedRoute.succeeded,
                        flashed: $viewModel.selectedRoute.flashed
                    )
                }
                NotesView(
                    isEditing: $isEditing,
                    notes: isEditing ? $viewModel.draftRoute.notes : $viewModel.selectedRoute.notes
                )
            }
            .transition(.slide)
            .animation(.default, value: isEditing)
        }
        .navigationBarTitle("Route Details", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar { toolbarContent }
        .alert(isPresented: $viewModel.showConfirmationDialog, content: confirmationAlert)
        .sheet(isPresented: $showingImageEditor) {
            ImageEditingView(climbingRoute: $viewModel.selectedRoute, imageData: $viewModel.selectedRoute.image)
        }
    }
    
    private var toolbarContent: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                editDoneButton
            }
        }
    }
    
    private var backButton: some View {
        Button(action: backButtonAction) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Back")
            }
        }
    }
    
    private var editDoneButton: some View {
        Button(isEditing ? "Done" : "Edit") {
            withAnimation {
                toggleEditing()
            }
        }
    }
    
    private func backButtonAction() {
        if isEditing {
            viewModel.showConfirmationDialog = true
        } else {
            navigateBack()
        }
    }
    
    private func toggleEditing() {
        if isEditing {
            saveUpdatedRoute()
        } else {
            viewModel.draftRoute = viewModel.selectedRoute.copy()
        }
        isEditing.toggle()
    }
    
    private func confirmationAlert() -> Alert {
        Alert(
            title: Text("Unsaved Changes"),
            message: Text("Do you want to save your changes before leaving?"),
            primaryButton: .default(Text("Save")){
                saveUpdatedRoute()
                navigateBack()
            },
            secondaryButton: .cancel(Text("Discard"), action: navigateBack)
        )
    }
    
    private func navigateBack() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func saveUpdatedRoute() {
        if case .success(let image) = viewModel.imageState {
            viewModel.draftRoute.image = image
        } else {
            viewModel.draftRoute.image = nil
        }
        viewModel.saveDraftRoute()
    }
}
