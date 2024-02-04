import SwiftUI
import Charts

struct RoutesByColor: Identifiable, Equatable {
    let id = UUID()
    let difficulty: RouteDifficulty
    let count: Double
}

struct ChartsView: View {
    @ObservedObject var climbingRoutesData: ClimbingRoutesData
    @State var showOnlySucceeded: Bool = false
    @State private var startDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @State private var endDate: Date = Date()
    
    private var routesByDifficulty: [RoutesByColor] {
        let filteredRoutes = showOnlySucceeded ? climbingRoutesData.testable
            .filter { $0.succeeded } : climbingRoutesData.testable
        let grouped = Dictionary(
            grouping: filteredRoutes
                .filter { route in
                    route.date >= startDate && route.date <= endDate
                },
            by: { $0.difficulty }
        )
        let countAll = climbingRoutesData.testable.count
        return grouped
            .sorted {
                $0.key.rawValue > $1.key.rawValue
            }
            .map {
                RoutesByColor(
                    difficulty: $0.key,
                    count: Double($0.value.count) / Double (countAll)
                )
            }
    }
    private var routeColors: [Color] {
        routesByDifficulty.map { $0.difficulty.color }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 12) {
                    DatePicker(
                        "From – to",
                        selection: $startDate,
                        in: Constants.dateRange,
                        displayedComponents: .date
                    )
                    .lineLimit(1, reservesSpace: true)
                    .pickerStyle(.inline)
                    .datePickerStyle(.compact)
                    .padding(.leading, 30)
                    DatePicker(
                        "",
                        selection: $endDate,
                        in: Constants.dateRange,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                    .pickerStyle(.inline)
                    .labelsHidden()
                    .padding(.trailing, 30)
                }
                Toggle(isOn: $showOnlySucceeded, label: {
                    Text("Only succeeded")
                })
                .padding(.horizontal, 30)
                Chart(routesByDifficulty) { route in
                    SectorMark(
                        angle: .value(
                            route.difficulty.rawValue,
                            route.count
                        ),
                        angularInset: 1.5
                    )
                    .cornerRadius(5)
                    .foregroundStyle(
                        by: .value(
                            Text(route.difficulty.rawValue),
                            route.difficulty.rawValue
                        )
                    )
                }
                .chartLegend(position: .bottom, alignment: .center)
                .chartForegroundStyleScale(range: routeColors)
                .animation(.bouncy, value: routesByDifficulty)
                .frame(width: 200, height: 400)
            }
            .navigationTitle("Charts")
        }
    }
}

#Preview {
    ChartsView(climbingRoutesData: ClimbingRoutesData())
}
