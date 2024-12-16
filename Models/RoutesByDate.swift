import Foundation

struct RouteByDate: Comparable {
    var count: Int
    var date: Date

    static func == (lhs: RouteByDate, rhs: RouteByDate) -> Bool {
        lhs.date == rhs.date
    }

    static func < (lhs: RouteByDate, rhs: RouteByDate) -> Bool {
        lhs.date < rhs.date
    }
}
