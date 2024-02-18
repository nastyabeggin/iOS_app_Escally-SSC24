import SwiftUI

struct RouteDetailsFieldsView: View {
    @Environment(\.colorScheme) var colorScheme

    @Binding var name: String
    @Binding var difficulty: RouteDifficulty
    @Binding var date: Date
    @Binding var succeeded: Bool
    @Binding var flashed: Bool

    var body: some View {
        Text(name)
            .foregroundStyle(.primary)
        HStack {
            Text("Difficulty")
            Spacer()
            Text(difficulty.rawValue)
                .foregroundStyle(difficulty.color)
            Circle()
                .fill(difficulty == .black && colorScheme == .dark ? .black : difficulty.color)
                .stroke(.white, lineWidth: difficulty == .black && colorScheme == .dark ? 1 : 0)
                .frame(width: 20)
        }
        HStack {
            Text("Date")
            Spacer()
            Text(date.formatted)
        }
        HStack {
            Text("Succeeded")
            Spacer()
            succeeded ?
            Text("Yes").foregroundStyle(.green) :
            Text("No").foregroundStyle(.red)
        }
        if succeeded {
            HStack {
                Text("Flashed")
                Spacer()
                flashed ?
                Text("Yes").foregroundStyle(.green)
                : Text("No").foregroundStyle(.red)
            }
        }
    }
}
