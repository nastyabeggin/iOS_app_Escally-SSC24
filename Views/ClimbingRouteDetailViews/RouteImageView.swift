import SwiftUI
import PhotosUI

struct RouteImageView: View {
    @Binding var isEditing: Bool
    @Binding var imageState: ImageState
    @Binding var selectedPickerItem: PhotosPickerItem?
    var imageData: Data?
    
    var body: some View {
        Group {
            if let imageData = imageData, !isEditing, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else if isEditing {
                ImagePickerView(
                    imageState: $imageState,
                    selectedPickerItem: $selectedPickerItem
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
