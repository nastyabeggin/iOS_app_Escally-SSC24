import SwiftUI

struct NoRoutesView: View {
    @State private var currentImageIndex = 0
    @State private var animationScale: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    private let images = RouteDifficulty.allCases.map { $0.rawValue.capitalized }

    var body: some View {
        ZStack {
            Color.clear
                .edgesIgnoringSafeArea(.all)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        currentImageIndex = (currentImageIndex + 1) % images.count
                    }
                }
            VStack {
                Image(images[currentImageIndex])
                    .resizable()
                    .frame(width: 50, height: 50)
                    .scaledToFit()
                    .scaleEffect(animationScale)
                    .opacity(opacity)
                    .onAppear {
                        let animation = Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)
                        withAnimation(animation) {
                            animationScale = 0.8
                            opacity = 0.5
                        }
                        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                            withAnimation(.easeInOut) {
                                currentImageIndex = (currentImageIndex + 1) % images.count
                            }
                        }
                    }
                
                Text("No routes")
                    .font(.title2)
                    .bold()
                
                Text("Go climbing and track your progress here!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }
}

#Preview {
    NoRoutesView()
}
