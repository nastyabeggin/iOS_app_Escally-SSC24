import SwiftUI
import PhotosUI

struct RouteImageView: View {
    @Binding var isEditing: Bool
    @Binding var imageState: ImageState
    @Binding var selectedPickerItem: PhotosPickerItem?
    @Binding var showingImageEditor: Bool
    var routeIsMarked: Bool
    var imageData: Data?
    private let viewMarkedRouteTip = ViewMarkedRouteTip()

    var body: some View {
        Group {
            if let imageData = imageData, !isEditing, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .onTapGesture {
                        showingImageEditor = true
                    }
                    .overlay(
                        HStack(spacing: 10) {
                            Image(systemName: "plus.magnifyingglass")
                                .font(.body)
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                                .onTapGesture {
                                    showingImageEditor = true
                                }
                                .popoverTip(viewMarkedRouteTip)
                            if routeIsMarked {
                                Text("Route is marked")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.black.opacity(0.5))
                                    .cornerRadius(10)
                            }
                        }
                        .padding([.top, .leading], 10),
                        alignment: .topLeading
                    )
            } else if isEditing {
                ImagePickerView(
                    imageState: $imageState,
                    selectedPickerItem: $selectedPickerItem,
                    showingImageEditor: $showingImageEditor
                )
            } else {
                Text("No Image")
                    .font(.title)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .frame(height: 200)
        .transition(.opacity)
        .animation(.default, value: isEditing)
    }
}
