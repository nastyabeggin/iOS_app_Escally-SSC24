import SwiftUI
import SwiftData

struct ImageEditingView: View {
    @Binding var climbingRoute: ClimbingRoute
    @Binding var imageData: Data?
    @Environment(\.presentationMode) var presentationMode
    @State private var tapPoints: [CGPoint] = []
    @State private var temporaryScale: CGFloat = 1.0
    @State private var deletedPoints: [CGPoint] = []
    
    @GestureState private var isPressingDown: Bool = false

    private var isShowingPoints: Bool {
        !isPressingDown && temporaryScale == 1.0
    }
    
    init(climbingRoute: Binding<ClimbingRoute>, imageData: Binding<Data?>) {
        self._climbingRoute = climbingRoute
        self._imageData = imageData
        self.tapPoints = climbingRoute.routeDots.wrappedValue ?? []
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                        .scaleEffect(temporaryScale)
                        .gesture(getZoomGesture())
                        .simultaneousGesture(getHideGesture())
                        .simultaneousGesture(getAddPointGesture())
                        .overlay(
                            Group {
                                if isShowingPoints {
                                    getMarksView()
                                        .zIndex(1)
                                    getPathView()
                                        .zIndex(0)
                                }
                            }
                                .animation(.default, value: isShowingPoints)
                        )
                }
                HStack(spacing: 40) {
                    HStack {
                        Button(action: {
                            undoLast()
                        }, label: {
                            Image(systemName: "arrow.uturn.backward")
                        })
                        .buttonStyle(CustomButtonStyle())
                        Button(action: {
                            redoLast()
                        }, label: {
                            Image(systemName: "arrow.uturn.forward")
                        })
                        .buttonStyle(CustomButtonStyle())
                    }
                    Button("Clear All") {
                        clearAll()
                    }
                    .buttonStyle(CustomButtonStyle())
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
        if let point = tapPoints.popLast() {
            deletedPoints.append(point)
        }
    }

    private func redoLast() {
        if let point = deletedPoints.popLast() {
            tapPoints.append(point)
        }
    }
    
    private func clearAll() {
        tapPoints.removeAll()
    }

    private func getMarksView() -> some View {
        ForEach(tapPoints.indices, id: \.self) { index in
            ZStack {
                Circle()
                    .stroke(.primary, lineWidth: 1)
                    .fill(.background)
                    .frame(width: 35, height: 35)
                Text("✋")
                    .font(.headline)
                Text("\(index + 1)")
                    .font(.caption2)
                    .foregroundColor(.black)
                    .padding(.trailing, 5)
                    .padding(.top, 9)
            }
            .position(tapPoints[index])
        }
    }

    private func getPathView() -> some View {
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
    }

    private func getZoomGesture() -> some Gesture {
        MagnificationGesture()
            .onChanged { value in
                self.temporaryScale = value
            }
            .onEnded { value in
                withAnimation {
                    self.temporaryScale = 1.0
                }
            }
    }

    private func getHideGesture() -> some Gesture {
        LongPressGesture(minimumDuration: 0.25)
            .sequenced(before: LongPressGesture(minimumDuration: .infinity))
            .updating($isPressingDown) { value, state, transaction in
                switch value {
                case .second(true, nil):
                    state = true
                default: break
                }
            }
    }

    private func getAddPointGesture() -> some Gesture {
        DragGesture(minimumDistance: 0).onEnded { value in
            let tapLocation = value.startLocation
            if isShowingPoints {
                tapPoints.append(tapLocation)
            }
        }
    }
}

#Preview {
    if let image = UIImage(systemName: "cellularbars"), let imageData = image.jpegData(compressionQuality: 1) {
        ImageEditingView(climbingRoute: .constant(.init(name: "", difficulty: .blue, date: .now, succeeded: true, flashed: true, notes: "")), imageData: .constant(imageData))
    } else {
        Text("Failed to load system image")
    }
}
