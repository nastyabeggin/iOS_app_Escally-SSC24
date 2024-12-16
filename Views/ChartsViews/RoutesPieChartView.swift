import SwiftUI
import Charts
import SwiftData

struct RoutesPieChartView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var context
    @Query private var routes: [ClimbingRoute]

    @Binding var showOnlySucceeded: Bool
    @Binding var startDate: Date
    @Binding var endDate: Date
    @State private var animate = false

    private var routesByDifficulty: [RoutesByColor] {
        let filteredRoutes = routes
            .filter { !showOnlySucceeded || $0.succeeded }
            .filter { $0.date.isBetween(startDate: startDate, endDate: endDate) }

        let grouped = Dictionary(grouping: filteredRoutes, by: \.difficulty)
        return grouped
            .sorted { $0.key.rawValue > $1.key.rawValue }
            .map { RoutesByColor(difficulty: $0.key, count: $0.value.count) }
    }

    private var routeColors: [Color] {
        routesByDifficulty.map {
            ($0.difficulty == .black && colorScheme == .dark) ? .gray : $0.difficulty.color
        }
    }

    var body: some View {
        Group {
            if routesByDifficulty.isEmpty {
                emptyStateView
            } else {
                pieChart
            }
        }
        .transition(.opacity)
        .animation(.easeInOut, value: routesByDifficulty)
    }

    private var emptyStateView: some View {
        Text("No data")
            .font(.title)
            .foregroundStyle(.secondary)
    }

    private var pieChart: some View {
        Chart(routesByDifficulty) { route in
            SectorMark(angle: .value(route.difficulty.rawValue, route.count), angularInset: 1.5)
                .cornerRadius(5)
                .foregroundStyle(by: .value(route.difficulty.rawValue, route.difficulty.rawValue))
                .annotation(position: .overlay) {
                    Text("\(route.count)")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
        }
        .chartLegend(position: .bottom, alignment: .center, spacing: 30)
        .font(.title)
        .chartForegroundStyleScale(range: routeColors)
    }
}

#Preview {
    RoutesPieChartView(
        showOnlySucceeded: .constant(true),
        startDate: .constant(.now),
        endDate: .constant(.now)
    )
}
