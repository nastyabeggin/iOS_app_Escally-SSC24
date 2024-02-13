import SwiftUI
import Charts

struct RoutesChartBarView: View {
    @Binding var selectedRange: [RouteByDate]
    @Binding var selectedTimeRange: [Date]
    @State private var scrollPosition = DateTimeHelper.getMondayOnCurrentWeek()
    @State private var selectedDate: Date? = nil
    @State private var visibleDomain = 3600 * 24 * 7
    @State private var xAxisStride: Calendar.Component = .day
    var allRoutesData: [RouteByDate]
    var timeRange: TimeRange
    
    var body: some View {
        Chart {
            ForEach(allRoutesData, id: \.date) { element in
                BarMark(
                    x: .value("Date", element.date, unit: xAxisStride),
                    y: .value("Number of Routes", element.count)
                )
            }
            if let selectedDate {
                RuleMark(
                    x: .value("Selected", selectedDate, unit: xAxisStride)
                )
                .foregroundStyle(Color.gray.opacity(0.3))
                .annotation(
                    position: .topLeading,
                    spacing: 0,
                    overflowResolution: .init(x: .fit(to: .chart), y: .fit(to: .chart))) {
                        // TODO: annotation
                        Text("test")
                    }
                    .zIndex(1)
            }
        }
        .chartXVisibleDomain(length: visibleDomain)
        .chartXSelection(value: $selectedDate)
        .chartScrollPosition(x: $scrollPosition)
        .chartScrollTargetBehavior(
            .valueAligned(matching: DateComponents(weekday: 2)))
        .chartXAxis {
            AxisMarks(values: getXAxisValues()) {
                AxisValueLabel(format: getXAxisLabelFormat(), centered: true)
                AxisGridLine()
                AxisTick()
            }
        }
        .onChange(of: scrollPosition) {
            updateSelectedRange(startingFrom: scrollPosition)
        }
        .onChange(of: timeRange) {
            updateSelectedRange(startingFrom: scrollPosition)
            visibleDomain = getVisibleDomain()
            xAxisStride = getXAxisStride()
        }
        .chartScrollableAxes(.horizontal)
        .animation(.default, value: timeRange)
    }
    
    private func updateSelectedRange(startingFrom date: Date) {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let startDatePlusDay = calendar.date(byAdding: .day, value: 1, to: startDate) ?? startDate
        guard let endDate = DateTimeHelper.getTimeInterval(startDate: startDatePlusDay, interval: timeRange) else { return }
        selectedTimeRange = [startDatePlusDay, endDate]
        
        selectedRange = allRoutesData.filter { route in
            DateTimeHelper.isRouteBetween(startDate: startDatePlusDay, endDate: endDate, climbingRouteDate: route.date)
        }
    }
    
    private func getVisibleDomain() -> Int {
        switch timeRange {
        case .week:
            return 3600 * 24 * 7
        case .month:
            return 3600 * 24 * 30
        case .sixMonths:
            return 3600 * 24 * 30 * 6
        case .year:
            return 3600 * 24 * 30 * 12
        }
    }
    
    private func getXAxisStride() -> Calendar.Component {
        switch timeRange {
        case .week:
            return .day
        case .month:
            return .day
        case .sixMonths:
            return .weekOfYear
        case .year:
            return .month
        }
    }
    
    private func getXAxisValues() -> AxisMarkValues {
        switch timeRange {
        case .week:
            return .stride(by: .day)
        case .month:
            return .automatic(desiredCount: 5)
        case .sixMonths:
            return .stride(by: .month)
        case .year:
            return .stride(by: .month)
        }
    }
    
    private func getXAxisLabelFormat() -> Date.FormatStyle {
        switch timeRange {
        case .week:
            return .dateTime.day(.defaultDigits).weekday()
        case .month:
            return .dateTime.day(.defaultDigits)
        case .sixMonths:
            return .dateTime.month(.abbreviated)
        case .year:
            return .dateTime.month(.abbreviated)
        }
    }
}
