import SwiftUI
import PhotosUI

struct ImagePickerView: View {
    @Binding var imageState: ImageState
    @Binding var selectedPickerItem: PhotosPickerItem?
    
    var body: some View {
        Section {
            switch imageState {
            case .empty:
                PhotosPicker(selection: $selectedPickerItem, matching: .images, photoLibrary: .shared()) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 30))
                        .foregroundColor(.accentColor)
                }
                .buttonStyle(.borderless)
                .frame(maxWidth: .infinity, alignment: .center)
            case .loading:
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, alignment: .center)
            case .success(let imageData):
                if let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .onTapGesture {
                            // add editing
                        }
                        .overlay(
                            Button(action: {
                                imageState = .empty
                            }) {
                                Image(systemName: "trash")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .padding(.all, 10)
                                    .background(
                                        LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.01), Color.black.opacity(0.5)]), startPoint: .bottomLeading, endPoint: .topTrailing)
                                            .clipShape(Circle())
                                    )
                            },
                            alignment: .topTrailing
                        )
                }
            case .failure:
                Text("Failed to load image")
            }
        }
        .frame(height: 200)
    }
}
