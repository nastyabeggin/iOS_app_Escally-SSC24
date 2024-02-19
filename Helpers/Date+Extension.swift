import Foundation

extension Date {
    var formatted: String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        if calendar.isDateInToday(self) {
            return "Today"
        } else if calendar.isDateInYesterday(self) {
            return "Yesterday"
        }
        let currentYear = calendar.component(.year, from: Date())
        let dateYear = calendar.component(.year, from: self)
        
        if currentYear == dateYear {
            dateFormatter.dateFormat = "d MMM"
        } else {
            dateFormatter.dateFormat = "d MMM yy"
        }
        
        return dateFormatter.string(from: self)
    }
    
    var startOfMonth: Date {

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)

        return  calendar.date(from: components)!
    }

    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    func startOfWeek() -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: self.startOfDay)
        let mondayInWeek = calendar.date(from: components)!
        return mondayInWeek
    }
    
    func isBetween(startDate: Date, endDate: Date) -> Bool {
        let startDay = startDate.startOfDay
        let endDay = endDate.startOfDay
        let routeDay = self.startOfDay
        return routeDay >= startDay && routeDay <= endDay
    }
        
    func addingTimeInterval(_ interval: TimeRange) -> Date? {
        let calendar = Calendar.current
        switch interval {
        case .week:
            return calendar.date(byAdding: .day, value: 6, to: self)
        case .month:
            return calendar.date(byAdding: .month, value: 1, to: self)
        case .sixMonths:
            return calendar.date(byAdding: .month, value: 6, to: self.endOfMonth())
        case .year:
            return calendar.date(byAdding: .year, value: 1, to: self.endOfMonth())
        }
    }
    
    func substractingTimeInterval(_ interval: TimeRange) -> Date? {
        let calendar = Calendar.current
        switch interval {
        case .week:
            return calendar.date(byAdding: .day, value: -6, to: self)
        case .month:
            return calendar.date(byAdding: .month, value: -1, to: self)
        case .sixMonths:
            return calendar.date(byAdding: .month, value: -6, to: self)
        case .year:
            return calendar.date(byAdding: .year, value: -1, to: self)
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
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth)!
    }
}
