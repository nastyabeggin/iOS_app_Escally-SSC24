import SwiftUI

struct AnnotationView: View {
    var totalRoutes: Int
    var date: Date
    var timeRange: TimeRange
    
    private var dateString: String {
        let dateFormatter = DateFormatter()
        switch timeRange {
        case .week, .month:
            dateFormatter.dateFormat = "d MMM yyyy"
            return dateFormatter.string(from: date)
        case .sixMonths:
            let startOfWeek = date.startOfWeek(using: .current)
            let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek)!
            return startOfWeek.timeRangeString(to: endOfWeek)
        case .year:
            dateFormatter.dateFormat = "MMM yyyy"
            return dateFormatter.string(from: date)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("TOTAL")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("\(totalRoutes)")
                .font(.title)
            Text(dateString)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
