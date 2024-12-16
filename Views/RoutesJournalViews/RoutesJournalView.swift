import SwiftUI
import Charts
import SwiftData

struct RoutesJournalView: View {
    @Environment(\.modelContext) var context
    @Query private var routes: [ClimbingRoute]

    @State private var selectedRouteRange: [RouteByDate] = []
    @State private var selectedTimeRange: [Date] = [Date().startOfWeek(), Calendar.current.date(byAdding: DateComponents(day: 6), to: Date().startOfWeek())!]
    @State private var averageRouteNumber: Int = 0
    @State private var timeRange: TimeRange = .week
    @State private var allRoutesData: [RouteByDate] = []
    private var filteredRoutes: [ClimbingRoute] {
        let filteredRoutes = routes.compactMap { route in
            route
        }
        return filteredRoutes
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 10)
                        .background(LinearGradient(colors: [.orange.opacity(0.3), .accentColor.opacity(0.5)],
                                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                    TimeRangePicker(timeRange: $timeRange)
                        .padding(.horizontal)
                    JournalTextView(selectedTimeRange: $selectedTimeRange, averageRouteNumber: $averageRouteNumber, timeRange: $timeRange)
                        .padding()
                    RoutesChartBarView(selectedRouteRange: $selectedRouteRange, selectedTimeRange: $selectedTimeRange, allRoutesData: $allRoutesData, timeRange: timeRange)
                        .frame(height: geometry.size.height / 2.5)
                        .padding()
                        .onChange(of: selectedTimeRange) {
                            DispatchQueue.main.async {
                                self.averageRouteNumber = self.calculateAverageRouteNumber()
                            }
                        }
                }
                .navigationTitle("Routes Journal")
            }
        }
        .onAppear {
            allRoutesData = calculateData()
            selectedRouteRange = calculateInitialRange()
            selectedTimeRange = calculateInitialTimeRange()
            averageRouteNumber = calculateAverageRouteNumber()
        }
    }

    private func calculateAverageRouteNumber() -> Int {
        let workoutDays = selectedRouteRange.filter { $0.count != 0 }.count
        let allRoutes = selectedRouteRange.map { $0.count }.reduce(0, +)

        guard workoutDays != 0 else { return 0 }

        switch timeRange {
        case .week, .month:
            return Int(round(Double(allRoutes) / Double(workoutDays)))
        case .sixMonths:
            // For 6 months assuming approximately 4.3 weeks in a month
            let weeksIn6Months = 6 * 4.3
            return Int(round((Double(allRoutes) / (Double(workoutDays)) / weeksIn6Months)))
        case .year:
            return Int(round((Double(allRoutes) / (Double(workoutDays)) / 12)))
        }
    }


    private func calculateInitialTimeRange() -> [Date] {
        let calendar = Calendar.current
        let startDate = Date().startOfWeek()
        let endDate = calendar.date(byAdding: DateComponents(day: 6), to: startDate)!
        return [startDate, endDate]
    }

    private func calculateInitialRange() -> [RouteByDate] {
        let calendar = Calendar.current
        let startDate = Date().startOfWeek()
        let endDate = calendar.date(byAdding: DateComponents(day: 6), to: startDate)!
        var currentDate = startDate
        var routesByDate = [RouteByDate]()
        while currentDate <= endDate {
            routesByDate.append(RouteByDate(count: 0, date: currentDate))
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        let groupedRoutes = Dictionary(grouping: filteredRoutes) { route in
            calendar.startOfDay(for: route.date)
        }
        for (date, routes) in groupedRoutes {
            if let index = routesByDate.firstIndex(where: { $0.date == date }) {
                routesByDate.remove(at: index)
                routesByDate.append(RouteByDate(count: routes.count, date: date))
            }
        }
        return routesByDate
    }

    private func calculateData() -> [RouteByDate] {
        let calendar = Calendar.current
        let startDate: Date = filteredRoutes
            .map { $0.date }
            .sorted()
            .min() ?? calendar.date(byAdding: .month, value: -6, to: Date())!
        let endDate: Date = filteredRoutes
            .map { $0.date }
            .sorted()
            .max() ?? calendar.date(byAdding: .weekOfMonth, value: 1, to: Date())!

        var routesByDate = [RouteByDate]()
        var currentDate = calendar.startOfDay(for: startDate)
        while currentDate <= endDate {
            routesByDate.append(RouteByDate(count: 0, date: currentDate))
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        let groupedRoutes = Dictionary(grouping: filteredRoutes) { route in
            calendar.startOfDay(for: route.date)
        }
        for (date, routes) in groupedRoutes {
            if let index = routesByDate.firstIndex(where: { $0.date == date }) {
                routesByDate.remove(at: index)
            }
            routesByDate.append(RouteByDate(count: routes.count, date: date))
        }
        return routesByDate
    }
}

#Preview {
    RoutesJournalView()
        .modelContainer( PreviewContainer([ClimbingRoute.self]).container)
}
