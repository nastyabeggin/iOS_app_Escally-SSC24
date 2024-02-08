import SwiftUI
import Charts

struct RoutesByColor: Identifiable, Equatable {
    let id = UUID()
    let difficulty: RouteDifficulty
    let count: Int
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
        return grouped
            .sorted {
                $0.key.rawValue > $1.key.rawValue
            }
            .map {
                RoutesByColor(
                    difficulty: $0.key,
                    count: $0.value.count
                )
            }
    }
    private var routeColors: [Color] {
        routesByDifficulty.map { $0.difficulty.color }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack (spacing: 20) {
                        HStack {
                            Text("Routes grouped by difficulty")
                                .font(.headline)
                                .padding(.leading)
                                .frame(alignment: .leading)
                            Spacer()
                        }
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
                            .padding(.leading)
                            DatePicker(
                                "",
                                selection: $endDate,
                                in: Constants.dateRange,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.compact)
                            .pickerStyle(.inline)
                            .labelsHidden()
                            .padding(.trailing)
                        }
                        .padding(.top, 30)
                        Toggle(isOn: $showOnlySucceeded, label: {
                            Text("Only succeeded")
                        })
                        .padding(.top, -10)
                        .padding(.horizontal)
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
                                    Text(route.difficulty.rawValue)
                                        .bold(),
                                    route.difficulty.rawValue
                                )
                            )
                            .annotation(position: .overlay) {
                                Text("\(route.count)")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                            }
                        }
                        .chartLegend(position: .bottom, alignment: .center, spacing: 30)
                        .font(.title)
                        .chartForegroundStyleScale(range: routeColors)
                        .animation(.bouncy, value: routesByDifficulty)
                        .frame(
                            width: geometry.size.width * 0.8,
                            height: geometry.size.height * 0.45
                        )
                        .padding(.vertical, geometry.size.height > 1024 ? 200 : 50)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle("Charts")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ChartsView(climbingRoutesData: ClimbingRoutesData())
}
