//

import SwiftUI

struct RouteDetailsFieldsView: View {
    @Binding var isEditing: Bool
    @Binding var name: String
    @Binding var difficulty: RouteDifficulty
    @Binding var date: Date
    @Binding var succeeded: Bool
    @Binding var flashed: Bool

    var body: some View {
        if isEditing {
            Section {
                TextField("Name", text: $name)
                Picker("Difficulty", selection: $difficulty) {
                    ForEach(RouteDifficulty.allCases) { difficulty in
                        Text(difficulty.rawValue).tag(difficulty)
                    }
                }
                .tint(difficulty.color)
                .pickerStyle(.menu)
                DatePicker("Date", selection: $date, displayedComponents: [.date])
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
        } else {
            Text(name)
                .foregroundStyle(.primary)
            HStack {
                Text("Difficulty")
                Spacer()
                Text(difficulty.rawValue)
                    .foregroundStyle(difficulty.color)
                Circle()
                    .fill(difficulty.color)
                    .frame(width: 20)
            }
            HStack {
                Text("Date")
                Spacer()
                Text(date.formatted(date: .complete, time: .omitted))
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
}


#Preview {
    RouteDetailsFieldsView(isEditing: .constant(false), name: .constant("name"), difficulty: .constant(.red), date: .constant(.now), succeeded: .constant(true), flashed: .constant(false))
}
