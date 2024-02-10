import SwiftUI

struct DatePickerSection: View {
    @Binding var startDate: Date
    @Binding var endDate: Date

    var body: some View {
        HStack(spacing: 12) {
            DatePicker("From – to", selection: $startDate, in: ...endDate, displayedComponents: .date)
                .padding(.leading)
            DatePicker("", selection: $endDate, in: startDate..., displayedComponents: .date)
                .labelsHidden()
                .padding(.trailing)
        }
        .padding(.top, 30)
    }
}


#Preview {
    DatePickerSection(startDate: .constant(.now), endDate: .constant(.now))
}
