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
    @State private var showDateLabel: Bool = true
    @State private var routesData: [Date: Int]  = [:]
    
    init(climbingRoutesData: ClimbingRoutesData) {
        self.climbingRoutesData = climbingRoutesData
        let calendar = Calendar.current
        let today = Date()
        var dateComponents = calendar.dateComponents([.year, .month, .day, .weekday], from: today)
        let daysToSubtract = (dateComponents.weekday! + 5) % 7
        dateComponents.day! -= daysToSubtract
        self._weekStartDate = State(initialValue: calendar.date(from: dateComponents)!)
        self._routesData = State(initialValue: self.calculateData(for: .week))
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // TODO: make picker work
                // TODO: Adjust scroll https://developer.apple.com/videos/play/wwdc2023/10037/?time=262
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
                RoutesChartBarView(routesData: routesData, timeRange: timeRange, showDateLabel: showDateLabel)
                    .frame(height: geometry.size.height / 3)
                    .padding()
                // TODO: add colors for chart
                    .onChange(of: timeRange) {
                        DispatchQueue.main.async {
                            self.routesData = self.calculateData(for: timeRange)
                        }
                    }
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
            }
            .onChange(of: weekStartDate) {
                self.showDateLabel = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        self.showDateLabel = true
                    }
                }
            }
            .onChange(of: timeRange) {
                updateChartForSelectedTimeRange()
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
        let workoutDays = routesData
            .values
            .filter { $0 != 0 }
            .count
        let allRoutes = routesData.values.reduce(0, +)
        
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
    
    private func calculateData(for timeRange: TimeRange) -> [Date: Int] {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        let startDate: Date
        let endDate: Date
        
        switch timeRange {
        case .week:
            startDate = weekStartDate
            dateComponents.day = 6
        case .month:
            startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: weekStartDate))!
            dateComponents.month = 1
            dateComponents.day = -1
        case .sixMonths:
            startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: weekStartDate))!
            dateComponents.month = 6
            dateComponents.day = -1
        case .year:
            startDate = calendar.date(from: calendar.dateComponents([.year], from: weekStartDate))!
            dateComponents.year = 1
            dateComponents.day = -1
        }
        
        endDate = calendar.date(byAdding: dateComponents, to: startDate)!
        var routesByDate = [Date: Int]()
        var currentDate = startDate
        while currentDate <= endDate {
            routesByDate[currentDate] = 0
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        let groupedRoutes = Dictionary(grouping: climbingRoutesData.testable) { route in
            calendar.startOfDay(for: route.date)
        }
        for (date, routes) in groupedRoutes {
            if let _ = routesByDate[date] {
                routesByDate[date] = routes.count
            }
        }
        return routesByDate
    }
    
    private func updateChartForSelectedTimeRange() {
        let calendar = Calendar.current
        
        switch timeRange {
        case .week:
            break
        case .month:
            weekStartDate = calendar.date(from: calendar.dateComponents([.year, .month], from: weekStartDate))!
        case .sixMonths, .year:
            weekStartDate = calendar.date(from: calendar.dateComponents([.year, .month], from: weekStartDate))!
        }
    }
    
}


#Preview {
    TimelineChartView(climbingRoutesData: ClimbingRoutesData())
}
