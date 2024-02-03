import SwiftUI
import PhotosUI

struct RouteImageView: View {
    @Binding var isEditing: Bool
    @Binding var imageState: ImageState
    @Binding var selectedPickerItem: PhotosPickerItem?
    var image: Image?
    
    var body: some View {
        Group {
            if let image = image, !isEditing {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else if isEditing || image == nil {
                ImagePickerView(
                    imageState: $imageState,
                    selectedPickerItem: $selectedPickerItem
                )
            }
        }
        .frame(height: 200)
        .transition(.opacity)
        .animation(.default, value: isEditing)
    }
}
