import SwiftUI
import Charts
import SwiftData

struct ChartsView: View {
    @Environment(\.modelContext) private var context
    @Query private var routes: [ClimbingRoute]

    @State private var showOnlySucceeded: Bool = false
    @State private var startDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @State private var endDate: Date = Date()

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 20) {
                        TitleView()
                        DatePickerSection(startDate: $startDate, endDate: $endDate)
                        SuccessToggle(showOnlySucceeded: $showOnlySucceeded)
                        RoutesPieChartView(
                            showOnlySucceeded: $showOnlySucceeded,
                            startDate: $startDate,
                            endDate: $endDate
                        )
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.45)
                        .padding(.top, geometry.size.height > 1024 ? 200 : 50)
                        ShowRoutesButtonView(
                            showOnlySucceeded: $showOnlySucceeded,
                            startDate: $startDate,
                            endDate: $endDate
                        )
                        .frame(height: 100)
                    }
                    .padding(.horizontal, 16)
                }
            }
            .navigationTitle("Charts")
        }
    }
}

#Preview {
    ChartsView()
        .modelContainer(PreviewContainer([ClimbingRoute.self]).container)
}
