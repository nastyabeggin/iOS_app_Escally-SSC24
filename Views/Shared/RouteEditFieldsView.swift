import SwiftUI

struct RouteEditFieldsView: View {
    @Binding var name: String
    @Binding var difficulty: RouteDifficulty
    @Binding var date: Date
    @Binding var succeeded: Bool
    @Binding var flashed: Bool

    var body: some View {
        Section {
            TextField("Name", text: $name)
            Picker("Difficulty", selection: $difficulty) {
                ForEach(RouteDifficulty.allCases) { difficulty in
                    Text(difficulty.rawValue).tag(difficulty)
                }
            }
            .tint(difficulty.color)
            .pickerStyle(.menu)
            DatePicker(
                "Date",
                selection: $date,
                in: Constants.dateRange,
                displayedComponents: [.date]
            )
            .datePickerStyle(.compact)
            .frame(maxHeight: 400)
            Toggle(isOn: $succeeded.animation()) {
                Text("Succeeded")
            }
            if succeeded {
                Toggle(isOn: $flashed) {
                    Text("Flashed")
                }
            }
        }
    }
}
