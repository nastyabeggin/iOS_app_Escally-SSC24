import SwiftUI

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        )
    }
    
    static var moveAndFadeBackwards: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .leading).combined(with: .opacity),
            removal: .move(edge: .trailing).combined(with: .opacity)
        )
    }
}

private extension View {
    func customTextModifier(forward: Bool = true) -> some View {
        self
            .zIndex(1)
            .font(.title2)
            .padding(.horizontal, 87)
            .transition(forward ? .moveAndFade : .moveAndFadeBackwards)
    }
}

struct WelcomeBox: View {
    @Binding var showWelcomeView: Bool
    @State private var switchMessage: Bool = false
    @State private var isMovingForward: Bool = true
    
    var body: some View {
        ZStack {
            BackgroundRectangle()
            WelcomeMessage()
            BottomButtons()
                .zIndex(1)
        }
        .frame(height: 320)
    }
    
    @ViewBuilder
    private func WelcomeMessage() -> some View {
        if !switchMessage {
            Text("It is an application created by a climber for all climbers")
                .customTextModifier(forward: isMovingForward)
        } else {
            Text("We will give you a tour on our application")
                .customTextModifier(forward: isMovingForward)
        }
    }
    
    @ViewBuilder
    private func BottomButtons() -> some View {
        if !switchMessage {
            SkipButton()
            ForwardButton()
        } else {
            BackwardButton()
            EndTourButton()
        }
    }
    
    private func SkipButton() -> some View {
        Button("Skip"){
            showWelcomeView = false
        }
        .buttonStyle(CustomButtonStyle())
        .offset(x: -90, y: 130)
    }
    
    private func ForwardButton() -> some View {
        Button(action: {
            isMovingForward = true
            withAnimation(.easeIn(duration: 0.5)) {
                switchMessage = true
            }
        }) {
            Image(systemName: "arrow.forward")
        }
        .buttonStyle(CustomButtonStyle())
        .offset(x: 100, y: 130)
    }
    
    private func BackwardButton() -> some View {
        Button(action: {
            isMovingForward = false
            withAnimation(.easeOut(duration: 0.5)) {
                switchMessage = false
            }
        }) {
            Image(systemName: "arrow.backward")
        }
        .buttonStyle(CustomButtonStyle())
        .offset(x: -100, y: 130)
    }
    
    private func EndTourButton() -> some View {
        Button(action: {
            withAnimation(.easeOut(duration: 0.5)) {
                showWelcomeView = false
            }
        }) {
            Image(systemName: "arrow.forward")
        }
        .buttonStyle(CustomButtonStyle())
        .offset(x: 100, y: 130)
    }
}

struct BackgroundRectangle: View {
    var body: some View {
        HStack {
            Spacer()
            Rectangle()
                .foregroundStyle(.clear)
                .background(Material.ultraThinMaterial)
                .cornerRadius(20)
            Spacer()
        }
        .zIndex(0)
        .padding(.horizontal, 57)
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundStyle(.black)
            .font(.title2)
    }
}

#Preview {
    WelcomeBox(showWelcomeView: .constant(true))
}
