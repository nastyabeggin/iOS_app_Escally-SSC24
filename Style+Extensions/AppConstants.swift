import SwiftUI

struct Constants {
    static var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let date = Date()
        guard let startDate = calendar.date(from: DateComponents(year: 1970, month: 1, day: 1)) else {
            Logger.error("Failed to create start date from components.")
            return date...date
        }
        return startDate...date
    }
}
