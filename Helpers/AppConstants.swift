import SwiftUI

struct Constants {
    static var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let date = Date()
        let startComponents = DateComponents(year: 1970, month: 1, day: 1)
        return calendar.date(from: startComponents)! ... date
    }
}

struct WelcomeButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundStyle(.primary)
            .font(.body)
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(.background.opacity(configuration.isPressed ? 0.5 : 1))
            .foregroundColor(.blue)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.accentColor, lineWidth: 1)
            )
            .shadow(color: .accentColor.opacity(0.3), radius: 3, x: 0, y: 3)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
