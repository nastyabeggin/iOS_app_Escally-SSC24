import SwiftUI
import Charts

enum TimeRange: String, CaseIterable, Identifiable {
    case week = "W"
    case month = "M"
    case sixMonths = "6M"
    case year = "Y"
    
    var id: String {
        self.rawValue
    }
    
    var description: String {
        self.rawValue
    }
}

struct TimelineChartView: View {
    @ObservedObject var climbingRoutesData: ClimbingRoutesData
    @State private var weekStartDate: Date
    @State private var timeRange: TimeRange = .week
    
    init(climbingRoutesData: ClimbingRoutesData) {
        self.climbingRoutesData = climbingRoutesData
        let calendar = Calendar.current
        let today = Date()
        var dateComponents = calendar.dateComponents([.year, .month, .day, .weekday], from: today)
        let daysToSubtract = (dateComponents.weekday! + 5) % 7
        dateComponents.day! -= daysToSubtract
        self._weekStartDate = State(initialValue: calendar.date(from: dateComponents)!)
    }
    
    private var weeklyRoutesData: [Date: Int] {
        let calendar = Calendar.current
        var weekDates: [Date] = []
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: weekStartDate) {
                weekDates.append(date)
            }
        }
        let groupedRoutes = Dictionary(grouping: climbingRoutesData.testable) { route in
            calendar.startOfDay(for: route.date)
        }
        var routesByDate: [Date: Int] = [:]
        weekDates.forEach { date in
            routesByDate[date] = groupedRoutes[date]?.count ?? 0
        }
        return routesByDate
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // TODO: make picker work
                Picker("TimeRange", selection: $timeRange) {
                    ForEach(TimeRange.allCases) { timeRange in
                        Text(timeRange.description.capitalized)
                            .tag(timeRange)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
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
                        Text(calculateAverageRouteNumber())
                            .font(.largeTitle)
                            .foregroundStyle(.primary)
                            .frame(alignment: .leading)
                        Text("routes")
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    HStack {
                        Text(getTimeRangeString())
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .frame(alignment: .leading)
                        Spacer()
                    }
                }
                .padding()
                Chart {
                    ForEach(weeklyRoutesData.keys.sorted(), id: \.self) { date in
                        BarMark(
                            x: .value("Date", date, unit: .day),
                            y: .value("Number of Routes", weeklyRoutesData[date, default: 0])
                        )
                        .foregroundStyle(by: .value("Date", date))
                    }
                }
                // TODO: add colors for chart
                .gesture (
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onEnded({ value in
                            if value.translation.width < 0 {
                                // TODO: stop scrolling if current week
                                navigateToNextWeek()
                            }
                            
                            if value.translation.width > 0 {
                                navigateToPreviousWeek()
                            }
                        })
                )
                .chartPlotStyle { plotArea in
                    plotArea
                        .frame(height: geometry.size.height / 3)
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) {
                        AxisValueLabel(format: .dateTime.day(.defaultDigits).weekday(), centered: true)
                        AxisGridLine()
                        AxisTick()
                    }
                }
                .chartYScale(domain: 0...(weeklyRoutesData.values.max()! + 3))
                .chartYAxis {
                    AxisMarks(values: .automatic(desiredCount: 3))
                }
                .padding()
            }
            .animation(.easeInOut(duration: 0.6), value: weekStartDate)
        }
    }
    
    private func navigateToPreviousWeek() {
        weekStartDate = Calendar.current.date(byAdding: .day, value: -7, to: weekStartDate) ?? weekStartDate
    }
    
    private func navigateToNextWeek() {
        weekStartDate = Calendar.current.date(byAdding: .day, value: 7, to: weekStartDate) ?? weekStartDate
    }
    
    private func calculateAverageRouteNumber() -> String {
        let workoutDays = weeklyRoutesData
            .values
            .filter { $0 != 0 }
            .count
        let allRoutes = weeklyRoutesData.values.reduce(0, +)
        
        return workoutDays == 0 ? "0" : String(allRoutes / workoutDays)
    }
    
    private func getTimeRangeString() -> String {
        let calendar = Calendar.current
        guard let weekEndDate = calendar.date(byAdding: .day, value: 6, to: weekStartDate) else {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        var startDay = dateFormatter.string(from: weekStartDate)
        if !calendar.isDate(weekStartDate, equalTo: weekEndDate, toGranularity: .month) {
            // TODO: check if year is the same
            dateFormatter.dateFormat = "d MMM"
            startDay = dateFormatter.string(from: weekStartDate)
            dateFormatter.dateFormat = "d MMM YYYY"
        }
        dateFormatter.dateFormat = "d MMM YYYY"
        let endDayMonth = dateFormatter.string(from: weekEndDate)
        
        return "\(startDay) – \(endDayMonth)"
    }
    
}


#Preview {
    TimelineChartView(climbingRoutesData: ClimbingRoutesData())
}
