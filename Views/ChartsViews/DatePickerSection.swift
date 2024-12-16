import SwiftUI

struct DatePickerSection: View {
    @Binding var startDate: Date
    @Binding var endDate: Date

    var body: some View {
        HStack(spacing: 12) {
            DatePicker(
                "From",
                selection: $startDate,
                in: ...endDate,
                displayedComponents: .date
            )
            .labelsHidden()
            .padding(.leading)

            DatePicker(
                "To",
                selection: $endDate,
                in: startDate...Constants.dateRange.upperBound,
                displayedComponents: .date
            )
            .labelsHidden()
            .padding(.trailing)
        }
        .padding(.vertical)
    }
}

#Preview {
    DatePickerSection(startDate: .constant(.now), endDate: .constant(.now))
}
