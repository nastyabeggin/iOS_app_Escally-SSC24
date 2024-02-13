import SwiftUI

struct ClimbingRouteRow: View {
    @State var route: ClimbingRoute

    var body: some View {
        HStack {
            if let image = route.image, let uiImage = UIImage(data: image) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .padding(.trailing, 8)
            }
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
