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
            .foregroundStyle(.primary)
            .font(.title3)
            .padding(.horizontal, 40)
            .transition(forward ? .moveAndFade : .moveAndFadeBackwards)
    }
}

struct WelcomeBox: View {
    @Binding var showWelcomeView: Bool
    @State private var switchMessage: Bool = false
    @State private var isMovingForward: Bool = true

    var body: some View {
            VStack {
                Spacer()
                if !switchMessage {
                    Text("It is an application created by a climber for all climbers")
                        .customTextModifier(forward: isMovingForward)
                } else {
                    Text("We will give you a tour on our application")
                        .customTextModifier(forward: isMovingForward)
                }
                Spacer()
                HStack {
                    if !switchMessage {
                        SkipButton()
                        Spacer()
                        ForwardButton()
                    } else {
                        BackwardButton()
                        Spacer()
                        EndTourButton()
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom)
                .zIndex(1)
            }
            .frame(width: 300, height: 250)
            .background(BackgroundRectangle())
    }

    private func SkipButton() -> some View {
        Button("Skip") {
            showWelcomeView = false
        }
        .buttonStyle(WelcomeButtonStyle())
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
        .buttonStyle(WelcomeButtonStyle())
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
        .buttonStyle(WelcomeButtonStyle())
    }

    private func EndTourButton() -> some View {
        Button(action: {
            withAnimation(.easeOut(duration: 0.5)) {
                showWelcomeView = false
            }
        }) {
            Image(systemName: "arrow.forward")
        }
        .buttonStyle(WelcomeButtonStyle())
    }
}

struct BackgroundRectangle: View {
    var body: some View {
        HStack {
            Spacer()
            Rectangle()
                .foregroundStyle(.ultraThinMaterial)
                .cornerRadius(20)
            Spacer()
        }
        .zIndex(0)
    }
}

#Preview {
    WelcomeBox(showWelcomeView: .constant(true))
}
