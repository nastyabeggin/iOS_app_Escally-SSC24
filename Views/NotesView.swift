import SwiftUI

struct NotesView: View {
    @Binding var isEditing: Bool
    @Binding var notes: String

    var body: some View {
        if isEditing {
            Section(header: Text("Notes")) {
                TextField("Additional info about the route", text: $notes, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .padding()
            }
        } else {
            Section(header: Text("Notes")) {
                Text(notes)
                    .textFieldStyle(.roundedBorder)
                    .padding()
            }
        }
    }
}

#Preview {
    NotesView(isEditing: .constant(false), notes: .constant("string"))
}
