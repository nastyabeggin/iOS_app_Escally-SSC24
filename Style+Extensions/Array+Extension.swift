import Foundation

extension Array where Element == RouteByDate {
    func groupByWeek(using dateKeyPath: KeyPath<Element, Date>) -> [[Element]] {
        let calendar = Calendar.current
        return Dictionary(grouping: self) { element in
            calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: element[keyPath: dateKeyPath])
        }
        .sorted(by: { $0.key.yearForWeekOfYear ?? 0 < $1.key.yearForWeekOfYear ?? 0 ||
                      ($0.key.yearForWeekOfYear == $1.key.yearForWeekOfYear &&
                       $0.key.weekOfYear ?? 0 < $1.key.weekOfYear ?? 0)
        })
        .map { $0.value }
    }

    func groupByMonth(using dateKeyPath: KeyPath<Element, Date>) -> [[Element]] {
        let calendar = Calendar.current
        return Dictionary(grouping: self) { element in
            calendar.dateComponents([.year, .month], from: element[keyPath: dateKeyPath])
        }
        .sorted(by: { $0.key.year ?? 0 < $1.key.year ?? 0 ||
                      ($0.key.year == $1.key.year &&
                       $0.key.month ?? 0 < $1.key.month ?? 0)
        })
        .map { $0.value }
    }
}
