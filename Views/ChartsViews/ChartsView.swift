import SwiftUI
import Charts
import SwiftData

struct ChartsView: View {
    @Environment(\.modelContext) var context
    @Query private var routes: [ClimbingRoute]

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
                        RoutesPieChartView(showOnlySucceeded: $showOnlySucceeded, startDate: $startDate, endDate: $endDate)
                            .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.45)
                            .padding(.top, geometry.size.height > 1024 ? 200 : 50)
                        ShowRoutesButtonView(showOnlySucceeded: $showOnlySucceeded, startDate: $startDate, endDate: $endDate)
                            .frame(height: 100)
                    }
                }
            }
            .navigationTitle("Charts")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ChartsView()
}
