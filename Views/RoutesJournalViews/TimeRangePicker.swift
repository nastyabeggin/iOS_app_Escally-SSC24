import SwiftUI

struct TimeRangePicker: View {
    @Binding var timeRange: TimeRange

    var body: some View {
        Picker("TimeRange", selection: $timeRange) {
            ForEach(TimeRange.allCases) { timeRange in
                Text(timeRange.description.capitalized)
                    .tag(timeRange)
            }
        }
        .pickerStyle(.segmented)
    }
}
