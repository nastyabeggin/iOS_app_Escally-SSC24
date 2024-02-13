import SwiftUI
import Charts

struct RoutesJournalView: View {
    @ObservedObject var climbingRoutesData: ClimbingRoutesData
    @State var selectedRouteRange: [RouteByDate] = []
    @State var selectedTimeRange: [Date] = []
    @State var averageRouteNumber: Int = 0
    @State private var timeRange: TimeRange = .week
    @State private var allRoutesData: [RouteByDate] = []
    
    init(climbingRoutesData: ClimbingRoutesData) {
        self.climbingRoutesData = climbingRoutesData
        self._allRoutesData = State(initialValue: self.calculateData())
        self._selectedRouteRange = State(initialValue: self.calculateInitialRange())
        self._selectedTimeRange = State(initialValue: self.calculateInitialTimeRange())
        self._averageRouteNumber = State(initialValue: self.calculateAverageRouteNumber())
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    TimeRangePicker(timeRange: $timeRange)
                        .padding(.horizontal)
                    JournalTextView(selectedTimeRange: $selectedTimeRange, averageRouteNumber: $averageRouteNumber)
                        .padding()
                    RoutesChartBarView(selectedRouteRange: $selectedRouteRange, selectedTimeRange: $selectedTimeRange, allRoutesData: allRoutesData, timeRange: timeRange)
                        .frame(height: geometry.size.height / 3)
                        .padding()
                        .onChange(of: selectedTimeRange) {
                            DispatchQueue.main.async {
                                self.averageRouteNumber = self.calculateAverageRouteNumber()
                            }
                        }
                }
            }
            .navigationTitle("Routes Journal")
        }
    }
    
    private func calculateAverageRouteNumber() -> Int {
        let workoutDays = selectedRouteRange
            .filter { $0.count != 0 }
            .count
        let allRoutes = selectedRouteRange
            .map { $0.count }
            .reduce(0, +)
        return workoutDays == 0 ? 0 : allRoutes / workoutDays
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
        let groupedRoutes = Dictionary(grouping: climbingRoutesData.testable) { route in
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
        var dateComponents = DateComponents()
        let startDate: Date = climbingRoutesData.testable
            .map { $0.date }
            .sorted()
            .min() ?? calendar.date(byAdding: .month, value: -6, to: Date())!
        let endDate: Date
        
        dateComponents.year = 1
        dateComponents.day = -1
        endDate = calendar.date(byAdding: dateComponents, to: Date())!
        var routesByDate = [RouteByDate]()
        var currentDate = calendar.startOfDay(for: startDate)
        while currentDate <= endDate {
            routesByDate.append(RouteByDate(count: 0, date: currentDate))
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        let groupedRoutes = Dictionary(grouping: climbingRoutesData.testable) { route in
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
    RoutesJournalView(climbingRoutesData: ClimbingRoutesData())
}
