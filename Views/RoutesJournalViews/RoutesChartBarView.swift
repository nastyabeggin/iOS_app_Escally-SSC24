import SwiftUI
import Charts

struct RoutesChartBarView: View {
    @Binding var selectedRouteRange: [RouteByDate]
    @Binding var selectedTimeRange: [Date]
    @Binding var allRoutesData: [RouteByDate]

    @State private var scrollPosition = Date().startOfWeek()
    @State private var selectedDate: Date? = nil
    @State private var visibleDomain = 3600 * 24 * 7
    @State private var xAxisStride: Calendar.Component = .day
    @State private var totalRoutes: Int = 0
    var timeRange: TimeRange
    private var currentTimeRangeData: [RouteByDate] {
        guard selectedTimeRange.count == 2 else { return [] }

        let calendar = Calendar.current
        var datesArray: [Date] = []
        var finalRoutes: [RouteByDate] = []

        let startDate = selectedTimeRange[0]
        let endDate = selectedTimeRange[1]

        var currentDate = startDate
        while currentDate <= endDate {
            datesArray.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        for date in datesArray {
            if let route = allRoutesData.first(where: { $0.date == date }) {
                finalRoutes.append(route)
            } else {
                let emptyRouteByDate = RouteByDate(count: 0, date: date)
                finalRoutes.append(emptyRouteByDate)
            }
        }
        return finalRoutes
    }
    
    var body: some View {
        Chart {
            ForEach(currentTimeRangeData, id: \.date) { element in
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
                .zIndex(0)
                .annotation(
                    position: .top,
                    spacing: 0,
                    overflowResolution: .init(x: .fit(to: .chart), y: .fit(to: .chart))) {
                        annotationView(for: selectedDate)
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
                AxisValueLabel(format: getXAxisLabelFormat())
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
        .onChange(of: selectedDate) {
            updateTotalRoutes()
        }
        .chartScrollableAxes(.horizontal)
        .animation(.default, value: timeRange)
    }
    
    private func updateSelectedRange(startingFrom date: Date) {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        guard let endDate = startDate.addingTimeInterval(timeRange), let currentDatePlusInterval = Date().addingTimeInterval(timeRange) else { return }
        if endDate > currentDatePlusInterval { return }
        DispatchQueue.global(qos: .userInitiated).async {
            let filteredRoutes = self.allRoutesData.filter { route in
                route.date.isBetween(startDate: startDate, endDate: endDate)
            }
            
            DispatchQueue.main.async {
                self.selectedTimeRange = [startDate, endDate]
                self.selectedRouteRange = filteredRoutes
            }
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
    
    private func updateTotalRoutes() {
        guard let selectedDate = selectedDate else {
            totalRoutes = 0
            return
        }
        
        let newTotalRoutes: Int
        switch timeRange {
        case .sixMonths:
            let startOfWeek = selectedDate.startOfWeek(using: .current)
            let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek)!
            newTotalRoutes = allRoutesData
                .filter { $0.date >= startOfWeek && $0.date <= endOfWeek }
                .reduce(0) { $0 + $1.count }
        case .year:
            newTotalRoutes = allRoutesData
                .filter { Calendar.current.isDate($0.date, equalTo: selectedDate, toGranularity: .month) }
                .reduce(0) { $0 + $1.count }
        default:
            newTotalRoutes = allRoutesData
                .filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
                .reduce(0) { $0 + $1.count }
        }
        self.totalRoutes = newTotalRoutes
    }
    
    private func annotationView(for date: Date) -> some View {
        AnnotationView(totalRoutes: totalRoutes, date: date, timeRange: timeRange)
    }
}
