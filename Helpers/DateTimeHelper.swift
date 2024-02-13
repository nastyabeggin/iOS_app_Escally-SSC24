import Foundation

struct DateTimeHelper {
    
    static func getMondayOnCurrentWeek() -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: Date())
        components.weekday = 2
        let mondayInWeek = calendar.date(from: components)!
        return mondayInWeek
    }
    
    static func isRouteBetween(startDate: Date, endDate: Date, climbingRouteDate: Date) -> Bool {
        let calendar = Calendar.current
        let startDay = calendar.startOfDay(for: startDate)
        let endDay = calendar.startOfDay(for: endDate)
        let routeDay = calendar.startOfDay(for: climbingRouteDate)
        return routeDay >= startDay && routeDay <= endDay
    }
    
    static func getTimeInterval(startDate: Date, interval: TimeRange) -> Date? {
        let calendar = Calendar.current
        switch interval {
        case .week:
            return calendar.date(byAdding: .day, value: 6, to: startDate)
        case .month:
            return calendar.date(byAdding: .month, value: 1, to: startDate)
        case .sixMonths:
            return calendar.date(byAdding: .month, value: 6, to: startDate)
        case .year:
            return calendar.date(byAdding: .year, value: 1, to: startDate)
        }
    }
    
    static func getTimeRangeString(startDate: Date, endDate: Date) -> String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        if calendar.isDate(startDate, equalTo: endDate, toGranularity: .year) {
            if calendar.isDate(startDate, equalTo: endDate, toGranularity: .month) {
                if calendar.isDate(startDate, equalTo: endDate, toGranularity: .day) {
                    dateFormatter.dateFormat = "d MMMM yyyy"
                    return dateFormatter.string(from: startDate)
                } else {
                    dateFormatter.dateFormat = "d"
                    let startDay = dateFormatter.string(from: startDate)
                    dateFormatter.dateFormat = "d MMMM yyyy"
                    let endDayMonthYear = dateFormatter.string(from: endDate)
                    return "\(startDay) - \(endDayMonthYear)"
                }
            } else {
                dateFormatter.dateFormat = "d MMM"
                let startDayMonth = dateFormatter.string(from: startDate)
                dateFormatter.dateFormat = "d MMM yyyy"
                let endDayMonthYear = dateFormatter.string(from: endDate)
                return "\(startDayMonth) - \(endDayMonthYear)"
            }
        } else {
            // Dates span different years, special case
            dateFormatter.dateFormat = "MMM yyyy"
            let startMonthYear = dateFormatter.string(from: startDate)
            let endMonthYear = dateFormatter.string(from: endDate)
            return "\(startMonthYear) – \(endMonthYear)"
        }
    }
}
