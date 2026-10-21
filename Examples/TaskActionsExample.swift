import SwiftUI
import SwipeRevealRow

struct TaskActionsExample: View {
    @State private var completed = false

    var body: some View {
        SwipeRevealRow(
            trailingActions: [
                SwipeRevealAction(title: "Done", systemImage: "checkmark.circle.fill", tint: .green) {
                    completed.toggle()
                },
                SwipeRevealAction(title: "More", systemImage: "ellipsis.circle.fill", tint: .blue) {
                    print("More actions tapped")
                }
            ],
            actionWidth: 76,
            revealThreshold: 0.4
        ) {
            HStack {
                Image(systemName: completed ? "checkmark.circle.fill" : "circle")
                Text("Prepare release notes")
                Spacer()
            }
            .padding()
        }
        .padding()
    }
}
