import SwiftUI

struct JournalTextView: View {
    @Binding var selectedTimeRange: [Date]
    @Binding var averageRouteNumber: Int
    @Binding var timeRange: TimeRange

    var body: some View {
        VStack {
            HStack(alignment: .lastTextBaseline, spacing: 5) {
                Text("AVERAGE")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(alignment: .leading)
                switch timeRange {
                case .week, .month:
                    Text("on workout days")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                case .sixMonths:
                    Text("per week")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                case .year:
                    Text("per month")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            HStack(alignment: .lastTextBaseline, spacing: 10) {
                Text(String(averageRouteNumber))
                    .font(.largeTitle)
                    .foregroundStyle(.primary)
                    .frame(alignment: .leading)
                Text(averageRouteNumber == 1 ? "route" : "routes")
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
