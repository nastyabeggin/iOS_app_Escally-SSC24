import Foundation

struct RouteByDate: Comparable {
    var count: Int
    var date: Date

    static func == (lhs: RouteByDate, rhs: RouteByDate) -> Bool {
        return lhs.date == rhs.date
    }

    static func < (lhs: RouteByDate, rhs: RouteByDate) -> Bool {
        return lhs.date < rhs.date
    }
}
