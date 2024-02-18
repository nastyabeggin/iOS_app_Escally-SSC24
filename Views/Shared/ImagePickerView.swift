import SwiftUI
import PhotosUI
import TipKit

struct ImagePickerView: View {
    @Binding var imageState: ImageState
    @Binding var selectedPickerItem: PhotosPickerItem?
    @Binding var showingImageEditor: Bool
    
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
                            showingImageEditor = true
                        }
                        .overlay(
                            Button(action: {
                                imageState = .empty
                            }) {
                                Image(systemName: "trash")
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                            }
                                .contentShape(Circle()),
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
