import Foundation

extension Array where Element == RouteByDate {
    func groupByWeek(using dateKeyPath: KeyPath<Element, Date>) -> [[Element]] {
        let calendar = Calendar.current
        return Dictionary(grouping: self) { element in
            calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: element[keyPath: dateKeyPath])
        }.values.map(Array.init)
    }

    func groupByMonth(using dateKeyPath: KeyPath<Element, Date>) -> [[Element]] {
        let calendar = Calendar.current
        return Dictionary(grouping: self) { element in
            calendar.dateComponents([.year, .month], from: element[keyPath: dateKeyPath])
        }.values.map(Array.init)
    }
}
