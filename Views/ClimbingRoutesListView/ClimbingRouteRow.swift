import SwiftUI

struct ClimbingRouteRow: View {
    @Binding var route: ClimbingRoute

    var body: some View {
        HStack {
            route.image?
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .padding(.trailing, 8)
            VStack(alignment: .leading) {
                    Text(route.name)
                        .font(.headline)
                HStack(alignment: .lastTextBaseline)
                {
                    Text(route.difficulty.rawValue)
                        .font(.subheadline)
                        .foregroundColor(route.difficulty.color)
                    Text(route.date.formatted(date: .numeric, time: .omitted))
                        .font(.footnote)
                }
            }
        }
    }
}

#Preview {
    ClimbingRouteRow(route: .constant(ClimbingRoute(id: UUID(), name: "Test name", difficulty: .red, image: Image(systemName: "mic"), date: .now, succeeded: true, flashed: false, notes: "No notes")))
}
