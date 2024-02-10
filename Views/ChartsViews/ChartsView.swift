import SwiftUI
import Charts

struct ChartsView: View {
    @ObservedObject var climbingRoutesData: ClimbingRoutesData
    @State var showOnlySucceeded: Bool = false
    @State private var startDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @State private var endDate: Date = Date()

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 20) {
                        TitleView()
                        DatePickerSection(startDate: $startDate, endDate: $endDate)
                        SuccessToggle(showOnlySucceeded: $showOnlySucceeded)
                        RoutesPieChartView(climbingRoutesData: climbingRoutesData, showOnlySucceeded: $showOnlySucceeded, startDate: $startDate, endDate: $endDate)
                            .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.45)
                            .padding(.vertical, geometry.size.height > 1024 ? 200 : 50)
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
