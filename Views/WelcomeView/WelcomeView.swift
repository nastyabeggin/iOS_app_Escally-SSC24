import SwiftUI

struct WelcomeView: View {
    @Binding var showWelcomeView: Bool
    @State private var animateGradient: Bool = true

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.orange.opacity(0.5), .accentColor.opacity(0.7)],
                               startPoint: animateGradient ? .topLeading : .bottomLeading, endPoint: animateGradient ? .bottomTrailing : .topTrailing)
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.linear(duration: 5).repeatForever(autoreverses: true)) {
                        animateGradient.toggle()
                    }
                }
                VStack(spacing: 47) {
                    VStack {
                        Text("Welcome to")
                            .font(.largeTitle)
                        Text("Escally")
                            .font(.largeTitle)
                            .bold()
                    }
                    WelcomeBox(showWelcomeView: $showWelcomeView)
                }
            }
        }
    }
}

#Preview {
    WelcomeView(showWelcomeView: .constant(true))
}
