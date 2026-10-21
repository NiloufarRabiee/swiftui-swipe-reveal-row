import SwiftUI
import SwipeRevealRow

private struct MailItem: Identifiable {
    let id = UUID()
    let subject: String
    let preview: String
    var isStarred = false
}

struct InboxExample: View {
    @State private var messages: [MailItem] = [
        .init(subject: "Design review", preview: "The updated screens look good."),
        .init(subject: "Project notes", preview: "Here is the meeting summary."),
        .init(subject: "Next steps", preview: "Let's review the prototype tomorrow.")
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(messages) { message in
                    SwipeRevealRow(
                        leadingActions: [
                            SwipeRevealAction(title: "Star", systemImage: "star.fill", tint: .orange) {
                                toggleStar(message.id)
                            }
                        ],
                        trailingActions: [
                            SwipeRevealAction(title: "Delete", systemImage: "trash.fill", tint: .red) {
                                messages.removeAll { $0.id == message.id }
                            }
                        ]
                    ) {
                        HStack(spacing: 12) {
                            Image(systemName: message.isStarred ? "star.fill" : "envelope")
                                .foregroundStyle(message.isStarred ? .orange : .primary)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(message.subject).font(.headline)
                                Text(message.preview).font(.subheadline).foregroundStyle(.secondary)
                            }
                            Spacer(minLength: 0)
                        }
                        .padding(16)
                    }
                }
            }
            .padding()
        }
    }

    private func toggleStar(_ id: UUID) {
        guard let index = messages.firstIndex(where: { $0.id == id }) else { return }
        messages[index].isStarred.toggle()
    }
}
