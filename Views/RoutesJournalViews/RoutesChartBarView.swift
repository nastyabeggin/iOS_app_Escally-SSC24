import SwiftUI
import Charts

struct RoutesChartBarView: View {
    var routesData: [Date: Int]
    var timeRange: TimeRange
    var showDateLabel: Bool

    var body: some View {
        Chart {
            ForEach(routesData.keys.sorted(), id: \.self) { date in
                BarMark(
                    x: .value("Date", date, unit: .day),
                    y: .value("Number of Routes", routesData[date, default: 0])
                )
            }
        }
        .chartXAxis(showDateLabel ? Visibility.visible : Visibility.hidden)
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) {
                AxisValueLabel(format: .dateTime.day(.defaultDigits).weekday(), centered: true)
                AxisGridLine()
                AxisTick()
            }
        }
        .chartYScale(domain: 0...(routesData.values.max() ?? 0 + 3))
        .chartYAxis {
            AxisMarks(values: .automatic(desiredCount: 3))
        }
    }
}


#Preview {
    RoutesChartBarView(routesData: [:], timeRange: .week, showDateLabel: true)
}
