import Foundation

extension Date {
    func startOfWeek() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components) ?? self
    }
    
    func isBetween(startDate: Date, endDate: Date) -> Bool {
        let startDay = startDate.startOfDay
        let endDay = endDate.startOfDay
        let routeDay = self.startOfDay
        return routeDay >= startDay && routeDay <= endDay
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    func addingTimeInterval(_ interval: TimeRange) -> Date? {
        let calendar = Calendar.current
        switch interval {
        case .week:
            return calendar.date(byAdding: .day, value: 6, to: self)
        case .month:
            return calendar.date(byAdding: .month, value: 1, to: self)
        case .sixMonths:
            return calendar.date(byAdding: .month, value: 6, to: self)
        case .year:
            return calendar.date(byAdding: .year, value: 1, to: self)
        }
    }

    func timeRangeString(to endDate: Date) -> String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        
        if calendar.isDate(self, equalTo: endDate, toGranularity: .year) {
            if calendar.isDate(self, equalTo: endDate, toGranularity: .month) {
                if calendar.isDate(self, equalTo: endDate, toGranularity: .day) {
                    dateFormatter.dateFormat = "d MMM yyyy"
                    return dateFormatter.string(from: self)
                } else {
                    dateFormatter.dateFormat = "d"
                    let startDay = dateFormatter.string(from: self)
                    dateFormatter.dateFormat = "d MMM yyyy"
                    let endDayMonthYear = dateFormatter.string(from: endDate)
                    return "\(startDay) - \(endDayMonthYear)"
                }
            } else {
                dateFormatter.dateFormat = "d MMM"
                let startDayMonth = dateFormatter.string(from: self)
                dateFormatter.dateFormat = "d MMM yyyy"
                let endDayMonthYear = dateFormatter.string(from: endDate)
                return "\(startDayMonth) - \(endDayMonthYear)"
            }
        } else {
            dateFormatter.dateFormat = "MMM yyyy"
            let startMonthYear = dateFormatter.string(from: self)
            let endMonthYear = dateFormatter.string(from: endDate)
            return "\(startMonthYear) – \(endMonthYear)"
        }
    }
    
    func startOfWeek(using calendar: Calendar) -> Date {
        calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }
}
