import SwiftUI
import Charts
import SwiftData

struct RoutesPieChartView: View {
    @Environment(\.modelContext) var context
    @Query private var routes: [ClimbingRoute]

    @Binding var showOnlySucceeded: Bool
    @Binding var startDate: Date
    @Binding var endDate: Date
    @State private var animate = false

    private var routesByDifficulty: [RoutesByColor] {
        let filteredRoutes = showOnlySucceeded ? routes.filter { $0.succeeded } : routes
        let grouped = Dictionary(grouping: filteredRoutes.filter { route in
            return route.date.isBetween(
                startDate: startDate,
                endDate: endDate
            )
        }, by: { $0.difficulty })
        return grouped.sorted { $0.key.rawValue > $1.key.rawValue }.map { RoutesByColor(difficulty: $0.key, count: $0.value.count) }
    }
    
    private var routeColors: [Color] {
        routesByDifficulty.map { $0.difficulty.color }
    }
    
    var body: some View {
        if routesByDifficulty.isEmpty {
            Text("No data")
                .font(.title)
                .foregroundStyle(.secondary)
                .transition(.asymmetric(insertion: .scale.combined(with: .opacity), removal: .opacity))
                .animation(.easeInOut, value: routesByDifficulty.isEmpty)
        } else {
            Chart(routesByDifficulty) { route in
                SectorMark(angle: .value(route.difficulty.rawValue, route.count), angularInset: 1.5)
                    .cornerRadius(5)
                    .foregroundStyle(by: .value(Text(route.difficulty.rawValue).bold(), route.difficulty.rawValue))
                    .annotation(position: .overlay) {
                        Text("\(route.count)").font(.headline).foregroundStyle(.white)
                    }
            }
            .chartLegend(position: .bottom, alignment: .center, spacing: 30)
            .font(.title)
            .chartForegroundStyleScale(range: routeColors)
            .transition(.opacity)
            .animation(.default, value: routesByDifficulty)
        }
    }
}


#Preview {
    RoutesPieChartView(showOnlySucceeded: .constant(true), startDate: .constant(.now), endDate: .constant(.now))
}
