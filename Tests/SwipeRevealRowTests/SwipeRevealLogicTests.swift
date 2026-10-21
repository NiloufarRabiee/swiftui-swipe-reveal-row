import XCTest
@testable import SwipeRevealRow

final class SwipeRevealLogicTests: XCTestCase {
    func testHorizontalDragWinsWhenItDominates() {
        XCTAssertTrue(SwipeRevealLogic.isHorizontalDrag(horizontal: 24, vertical: 5))
    }
    func testVerticalDragDoesNotClaimSwipe() {
        XCTAssertFalse(SwipeRevealLogic.isHorizontalDrag(horizontal: 5, vertical: 24))
    }
    func testZeroTranslationDoesNotClaimSwipe() {
        XCTAssertFalse(SwipeRevealLogic.isHorizontalDrag(horizontal: 0, vertical: 0))
    }
    func testClampingLeadingReveal() {
        XCTAssertEqual(SwipeRevealLogic.clampedOffset(currentOffset: 0, translation: 300, leadingWidth: 84, trailingWidth: 168), 84)
    }
    func testClampingTrailingReveal() {
        XCTAssertEqual(SwipeRevealLogic.clampedOffset(currentOffset: 0, translation: -300, leadingWidth: 84, trailingWidth: 168), -168)
    }
    func testNoActionsMeansNoReveal() {
        XCTAssertEqual(SwipeRevealLogic.clampedOffset(currentOffset: 0, translation: -90, leadingWidth: 0, trailingWidth: 0), 0)
    }
    func testRevealLeadingWhenPastThreshold() {
        XCTAssertEqual(SwipeRevealLogic.targetOffset(currentOffset: 0, predictedTranslation: 45, leadingWidth: 84, trailingWidth: 84), 84)
    }
    func testRevealTrailingWhenPastThreshold() {
        XCTAssertEqual(SwipeRevealLogic.targetOffset(currentOffset: 0, predictedTranslation: -45, leadingWidth: 84, trailingWidth: 84), -84)
    }
    func testSmallSwipeReturnsToClosed() {
        XCTAssertEqual(SwipeRevealLogic.targetOffset(currentOffset: 0, predictedTranslation: 20, leadingWidth: 84, trailingWidth: 84), 0)
    }
    func testSmallReverseSwipeKeepsRowOpen() {
        XCTAssertEqual(SwipeRevealLogic.targetOffset(currentOffset: -84, predictedTranslation: 10, leadingWidth: 84, trailingWidth: 84), -84)
    }
    func testReverseSwipeClosesRow() {
        XCTAssertEqual(SwipeRevealLogic.targetOffset(currentOffset: -84, predictedTranslation: 60, leadingWidth: 84, trailingWidth: 84), 0)
    }
    func testZeroWidthSideNeverOpens() {
        XCTAssertEqual(SwipeRevealLogic.targetOffset(currentOffset: 0, predictedTranslation: 100, leadingWidth: 0, trailingWidth: 84), 0)
    }
    func testThresholdIsClamped() {
        XCTAssertEqual(SwipeRevealLogic.targetOffset(currentOffset: 0, predictedTranslation: 1, leadingWidth: 84, trailingWidth: 84, threshold: -10), 84)
    }
}
