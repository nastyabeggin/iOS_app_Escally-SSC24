import SwiftUI

struct Constants {
    static var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let date = Date()
        let startComponents = DateComponents(year: 1970, month: 1, day: 1)
        return calendar.date(from: startComponents)! ... date
    }
}
