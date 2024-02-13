import SwiftUI

struct JournalTextView: View {
    @Binding var selectedTimeRange: [Date]
    @Binding var averageRouteNumber: Int
    
    var body: some View {
        VStack {
            HStack(alignment: .lastTextBaseline, spacing: 5) {
                Text("AVERAGE")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(alignment: .leading)
                Text("on workout days")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            HStack(alignment: .lastTextBaseline, spacing: 10) {
                Text(String(averageRouteNumber))
                    .font(.largeTitle)
                    .foregroundStyle(.primary)
                    .frame(alignment: .leading)
                Text("routes")
                    .foregroundStyle(.secondary)
                Spacer()
            }
            HStack {
                Text(selectedTimeRange[0].timeRangeString(to: selectedTimeRange[1]))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(alignment: .leading)
                Spacer()
            }
        }
    }
}
