import SwiftUI

struct SuccessToggle: View {
    @Binding var showOnlySucceeded: Bool

    var body: some View {
        Toggle(isOn: $showOnlySucceeded) {
            Text("Only succeeded")
        }
        .padding(.top, -10)
        .padding(.horizontal)
    }
}


#Preview {
    SuccessToggle(showOnlySucceeded: .constant(true))
}
