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
        
        let isSameYear = calendar.isDate(self, equalTo: Date(), toGranularity: .year)
        dateFormatter.dateFormat = isSameYear ? "d MMM" : "d MMM yy"
        return dateFormatter.string(from: self)
    }
    
    var startOfMonth: Date {
        let calendar = Calendar(identifier: .gregorian)
        guard let date = calendar.date(from: calendar.dateComponents([.year, .month], from: self)) else {
            Logger.error("Failed to calculate start of month for date: \(self)")
            return self
        }
        return date
    }

    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    func startOfWeek() -> Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: self.startOfDay)
        guard let mondayInWeek = calendar.date(from: components) else {
            Logger.error("Failed to calculate start of week for date: \(self)")
            return nil
        }
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
            guard let endOfMonthDate = self.endOfMonth() else {
                Logger.error("Failed to calculate end of month for adding time interval.")
                return nil
            }
            return calendar.date(byAdding: .month, value: 6, to: endOfMonthDate)
        case .year:
            guard let endOfMonthDate = self.endOfMonth() else {
                Logger.error("Failed to calculate end of month for adding time interval.")
                return nil
            }
            return calendar.date(byAdding: .year, value: 1, to: endOfMonthDate)
        }
    }
    
    func subtractingTimeInterval(_ interval: TimeRange) -> Date? {
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
    
    func startOfWeek(using calendar: Calendar = .current) -> Date? {
        let components = calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self)
        guard let date = components.date else {
            Logger.error("Failed to calculate start of week using calendar: \(calendar)")
            return nil
        }
        return date
    }
    
    func endOfMonth() -> Date? {
        guard let date = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth) else {
            Logger.error("Failed to calculate end of month for date: \(self)")
            return nil
        }
        return date
    }
}
