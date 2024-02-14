import SwiftUI

struct ImageEditingView: View {
    @Binding var imageData: Data?
    @Environment(\.presentationMode) var presentationMode
    @State private var tapPoints: [CGPoint] = []
    @State private var shapesVisible = true
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Image(uiImage: UIImage(data: imageData!)!)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0).onEnded { value in
                                let tapLocation = value.startLocation
                                tapPoints.append(tapLocation)
                            }
                        )
                        .overlay(
                            Group {
                                if shapesVisible {
                                    Path { path in
                                        for (index, point) in tapPoints.enumerated() {
                                            if index == 0 {
                                                path.move(to: point)
                                            } else {
                                                path.addLine(to: point)
                                            }
                                        }
                                    }
                                    .stroke(Color.accentColor, lineWidth: 2)
                                    
                                    ForEach(tapPoints.indices, id: \.self) { index in
                                        ZStack {
                                            Circle()
                                                .fill(.background)
                                                .stroke(.primary, lineWidth: 1)
                                                .frame(width: 30, height: 30)
                                            Text("\(index + 1)")
                                                .font(.caption)
                                                .foregroundColor(.primary)
                                        }
                                        .position(tapPoints[index])
                                    }
                                }
                            }
                        )
                        .simultaneousGesture(
                            LongPressGesture().onChanged { _ in
                                shapesVisible = false
                            }
                                .onEnded { _ in
                                    shapesVisible = true
                                }
                        )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                HStack {
                    Button("Undo") {
                        undoLast()
                    }
                    
                    Button("Clear All") {
                        clearAll()
                    }
                }
                .padding()
            }
            .navigationBarItems(leading: Button("Discard") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                // TODO: Add save logic here
                presentationMode.wrappedValue.dismiss()
            })
            .navigationBarTitle("Edit Image", displayMode: .inline)
        }
    }
    
    private func undoLast() {
        if !tapPoints.isEmpty {
            tapPoints.removeLast()
        }
    }
    
    private func clearAll() {
        tapPoints.removeAll()
    }
}

struct ImageEditingView_Previews: PreviewProvider {
    static var previews: some View {
        if let image = UIImage(systemName: "cellularbars"), let imageData = image.jpegData(compressionQuality: 1) {
            ImageEditingView(imageData: .constant(imageData))
        } else {
            Text("Failed to load system image")
        }
    }
}
