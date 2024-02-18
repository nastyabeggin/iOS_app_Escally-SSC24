import SwiftUI

struct ClimbingRouteRow: View {
    @State var route: ClimbingRoute

    var body: some View {
        HStack {
            Image(route.difficulty.rawValue.capitalized)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding(.trailing, 8)
            VStack(alignment: .leading) {
                Text(route.name)
                    .font(.headline)
                Text(route.difficulty.rawValue)
                    .font(.subheadline)
                    .foregroundColor(route.difficulty.color)
            }
            Spacer()
            Text(route.date.formatted)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .foregroundStyle(.secondary)
        }
    }
}
