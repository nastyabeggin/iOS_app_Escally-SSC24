import SwiftUI

struct TitleView: View {
    var body: some View {
        HStack {
            Text("Routes grouped by difficulty")
                .font(.headline)
                .padding(.leading)
            Spacer()
        }
    }
}

#Preview {
    TitleView()
}
