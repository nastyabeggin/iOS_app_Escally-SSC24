import SwiftUI

struct WelcomeView: View {
    @Binding var showWelcomeView: Bool
    
    var body: some View {
        ZStack {
            CustomBackgroundView()
            VStack(spacing: 47) {
                VStack {
                    Text("Welcome to")
                        .font(.system(.largeTitle))
                    Text("Escally")
                        .font(.system(.largeTitle))
                        .bold()
                }
                WelcomeBox(showWelcomeView: $showWelcomeView)
            }
            .padding(.top, -130)
        }
    }
}

#Preview {
    WelcomeView(showWelcomeView: .constant(true))
}
