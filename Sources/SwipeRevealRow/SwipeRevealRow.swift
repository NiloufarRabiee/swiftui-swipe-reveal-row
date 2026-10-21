#if canImport(SwiftUI)
import SwiftUI

public struct SwipeRevealAction: Identifiable {
    public let id: UUID
    public let title: String
    public let systemImage: String
    public let tint: Color
    let handler: () -> Void

    public init(id: UUID = UUID(), title: String, systemImage: String, tint: Color, action: @escaping () -> Void) {
        self.id = id
        self.title = title
        self.systemImage = systemImage
        self.tint = tint
        self.handler = action
    }
}

public struct SwipeRevealRow<Content: View>: View {
    private let leadingActions: [SwipeRevealAction]
    private let trailingActions: [SwipeRevealAction]
    private let actionWidth: CGFloat
    private let revealThreshold: Double
    private let cornerRadius: CGFloat
    private let content: Content

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var settledOffset: CGFloat = 0
    @State private var dragTranslation: CGFloat = 0
    @State private var isHorizontalDrag = false

    public init(
        leadingActions: [SwipeRevealAction] = [],
        trailingActions: [SwipeRevealAction] = [],
        actionWidth: CGFloat = 84,
        revealThreshold: Double = 0.45,
        cornerRadius: CGFloat = 12,
        @ViewBuilder content: () -> Content
    ) {
        self.leadingActions = leadingActions
        self.trailingActions = trailingActions
        self.actionWidth = max(56, actionWidth)
        self.revealThreshold = min(max(revealThreshold, 0), 1)
        self.cornerRadius = max(0, cornerRadius)
        self.content = content()
    }

    public var body: some View {
        ZStack(alignment: .leading) {
            HStack(spacing: 0) {
                ForEach(leadingActions) { action in actionButton(action) }
                Spacer(minLength: 0)
                ForEach(trailingActions) { action in actionButton(action) }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            content
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .offset(x: displayedOffset)
                .simultaneousGesture(dragGesture)
                .accessibilityActions {
                    ForEach(leadingActions + trailingActions) { action in
                        Button(action.title) { perform(action) }
                    }
                }
        }
        .frame(maxWidth: .infinity)
        .clipped()
        .onChange(of: leadingActions.count) { _ in resetIfNeeded() }
        .onChange(of: trailingActions.count) { _ in resetIfNeeded() }
    }

    private var leadingWidth: Double { Double(leadingActions.count) * Double(actionWidth) }
    private var trailingWidth: Double { Double(trailingActions.count) * Double(actionWidth) }

    private var displayedOffset: CGFloat {
        CGFloat(SwipeRevealLogic.clampedOffset(
            currentOffset: Double(settledOffset),
            translation: Double(dragTranslation),
            leadingWidth: leadingWidth,
            trailingWidth: trailingWidth
        ))
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 12)
            .onChanged { value in
                if !isHorizontalDrag {
                    guard SwipeRevealLogic.isHorizontalDrag(
                        horizontal: Double(value.translation.width),
                        vertical: Double(value.translation.height)
                    ) else { return }
                    isHorizontalDrag = true
                }
                dragTranslation = value.translation.width
            }
            .onEnded { value in
                guard isHorizontalDrag else {
                    dragTranslation = 0
                    return
                }
                let destination = SwipeRevealLogic.targetOffset(
                    currentOffset: Double(settledOffset),
                    predictedTranslation: Double(value.predictedEndTranslation.width),
                    leadingWidth: leadingWidth,
                    trailingWidth: trailingWidth,
                    threshold: revealThreshold
                )
                withAnimation(reduceMotion ? nil : .easeOut(duration: 0.22)) {
                    settledOffset = CGFloat(destination)
                    dragTranslation = 0
                }
                isHorizontalDrag = false
            }
    }

    private func actionButton(_ action: SwipeRevealAction) -> some View {
        Button { perform(action) } label: {
            VStack(spacing: 4) {
                Image(systemName: action.systemImage).font(.title3)
                Text(action.title).font(.caption2.weight(.semibold)).lineLimit(1)
            }
            .foregroundStyle(.white)
            .frame(width: actionWidth)
            .frame(maxHeight: .infinity)
            .background(action.tint)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(action.title)
    }

    private func perform(_ action: SwipeRevealAction) {
        withAnimation(reduceMotion ? nil : .easeOut(duration: 0.2)) {
            settledOffset = 0
            dragTranslation = 0
        }
        action.handler()
    }

    private func resetIfNeeded() {
        settledOffset = CGFloat(SwipeRevealLogic.clampedOffset(
            currentOffset: Double(settledOffset),
            translation: 0,
            leadingWidth: leadingWidth,
            trailingWidth: trailingWidth
        ))
    }
}
#endif
