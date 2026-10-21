import Foundation

/// Gesture calculations kept independent of SwiftUI for deterministic tests.
public enum SwipeRevealLogic {
    public static func isHorizontalDrag(horizontal: Double, vertical: Double, dominanceRatio: Double = 1.2) -> Bool {
        guard horizontal.isFinite, vertical.isFinite else { return false }
        return abs(horizontal) > abs(vertical) * max(1, dominanceRatio)
    }

    public static func clampedOffset(currentOffset: Double, translation: Double, leadingWidth: Double, trailingWidth: Double) -> Double {
        min(max(currentOffset + translation, -max(0, trailingWidth)), max(0, leadingWidth))
    }

    public static func targetOffset(currentOffset: Double, predictedTranslation: Double, leadingWidth: Double, trailingWidth: Double, threshold: Double = 0.45) -> Double {
        let leading = max(0, leadingWidth)
        let trailing = max(0, trailingWidth)
        let fraction = min(max(threshold, 0), 1)
        let projected = clampedOffset(currentOffset: currentOffset, translation: predictedTranslation, leadingWidth: leading, trailingWidth: trailing)
        if leading > 0 && projected > 0 && projected >= leading * fraction { return leading }
        if trailing > 0 && projected < 0 && -projected >= trailing * fraction { return -trailing }
        return 0
    }
}
