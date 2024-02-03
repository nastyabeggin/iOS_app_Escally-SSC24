import SwiftUI

struct ClimbingRouteRow: View {
    @Binding var route: ClimbingRoute

    var body: some View {
        HStack {
            route.image?
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .padding(.trailing, 8)

            VStack(alignment: .leading) {
                Text(route.name)
                    .font(.headline)
                Text(route.difficulty.rawValue)
                    .font(.subheadline)
                    .foregroundColor(route.difficulty.color)
            }
        }
    }
}