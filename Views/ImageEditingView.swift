import SwiftUI
import SwiftData

struct ImageEditingView: View {
    @Binding var climbingRoute: ClimbingRoute
    @Binding var imageData: Data?
    @Environment(\.presentationMode) var presentationMode
    @State private var tapPoints: [CGPoint] = []
    @State private var temporaryScale: CGFloat = 1.0
    
    @GestureState private var isPressingDown: Bool = false
    
    init(climbingRoute: Binding<ClimbingRoute>, imageData: Binding<Data?>) {
        self._climbingRoute = climbingRoute
        self._imageData = imageData
        self.tapPoints = climbingRoute.routeDots.wrappedValue ?? []
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Image(uiImage: UIImage(data: imageData!)!)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                        .scaleEffect(temporaryScale)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    self.temporaryScale = value
                                }
                                .onEnded { value in
                                    withAnimation {
                                        self.temporaryScale = 1.0
                                    }
                                }
                        )
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 0.25)
                                .sequenced(before: LongPressGesture(minimumDuration: .infinity))
                                .updating($isPressingDown) { value, state, transaction in
                                    switch value {
                                    case .second(true, nil):
                                        state = true
                                    default: break
                                    }
                                }
                        )
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0).onEnded { value in
                                let tapLocation = value.startLocation
                                if !isPressingDown {
                                    tapPoints.append(tapLocation)
                                }
                            }
                        )
                        .overlay(
                            Group {
                                if !isPressingDown && temporaryScale == 1.0 {
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
                                            Text("✋")
                                                .font(Font.custom("", size: 40, relativeTo: .title))
                                            Text("\(index + 1)")
                                                .font(.headline)
                                                .foregroundColor(.black)
                                                .padding(.trailing, 5)
                                                .padding(.top, 9)
                                        }
                                        .position(tapPoints[index])
                                    }
                                }
                            }
                        )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                HStack {
                    Button("Undo") {
                        undoLast()
                    }
                    .buttonStyle(.bordered)
                    Button("Clear All") {
                        clearAll()
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
            .onAppear {
                tapPoints = climbingRoute.routeDots ?? []
            }
            .navigationBarItems(leading: Button("Discard") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                climbingRoute.routeDots = tapPoints
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

#Preview {
    if let image = UIImage(systemName: "cellularbars"), let imageData = image.jpegData(compressionQuality: 1) {
        ImageEditingView(climbingRoute: .constant(.init(name: "", difficulty: .blue, date: .now, succeeded: true, flashed: true, notes: "")), imageData: .constant(imageData))
    } else {
        Text("Failed to load system image")
    }
}
