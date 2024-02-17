import SwiftUI

struct ShowRoutesButtonView: View {
    @Binding var showOnlySucceeded: Bool
    @Binding var startDate: Date
    @Binding var endDate: Date

    var body: some View {
        List {
            Section(header: Text("Options")) {
                NavigationLink(destination: SelectedRoutesListView(showOnlySucceeded: showOnlySucceeded, startDate: startDate, endDate: endDate)) {
                    Text("Show Routes")
                        .foregroundColor(.primary)
                }
            }
        }
        .listStyle(.plain)
    }
}
