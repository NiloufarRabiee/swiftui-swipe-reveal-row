# SwipeRevealRow

A reusable SwiftUI row with **bidirectional swipe actions, gesture-aware scrolling, snap thresholds, and accessibility actions**.

![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange)
![iOS](https://img.shields.io/badge/iOS-16%2B-blue)
![macOS](https://img.shields.io/badge/macOS-13%2B-blue)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## Features

- Leading and trailing swipe actions
- Multiple actions per side
- Configurable action width and snap threshold
- Velocity-aware settling with predicted drag translation
- Horizontal gesture detection to preserve vertical scrolling
- Accessible actions without requiring a swipe
- Reduced-motion support
- Pure gesture calculations with unit tests
- Swift Package Manager; no external dependencies

## Requirements

Swift 5.9+, iOS 16+ or macOS 13+.

## Installation

In Xcode, choose **File > Add Package Dependencies...** and enter:

`https://github.com/NiloufarRabiee/swiftui-swipe-reveal-row`

Add the `SwipeRevealRow` library to your target and import `SwipeRevealRow`.

## Usage

```swift
SwipeRevealRow(
    leadingActions: [
        SwipeRevealAction(title: "Pin", systemImage: "pin.fill", tint: .orange) {
            pinItem()
        }
    ],
    trailingActions: [
        SwipeRevealAction(title: "Delete", systemImage: "trash.fill", tint: .red) {
            deleteItem()
        }
    ]
) {
    HStack {
        Text("Swipe this row")
        Spacer()
    }
    .padding()
}
```

Place rows in a `LazyVStack` inside a `ScrollView` to create a scrolling list.

## Configuration

| Parameter | Default | Description |
| --- | --- | --- |
| `leadingActions` | `[]` | Actions revealed by swiping right |
| `trailingActions` | `[]` | Actions revealed by swiping left |
| `actionWidth` | `84` | Width of each action in points; minimum 56 |
| `revealThreshold` | `0.45` | Fraction of action area required to snap open |
| `cornerRadius` | `12` | Corner radius of foreground row |

## Behavior and accessibility

A horizontal swipe is recognized only when horizontal movement dominates vertical movement. The offset is constrained by the available actions, and predicted end translation determines settling. Actions are also available as accessibility actions, without requiring a gesture. The snap animation is disabled when Reduce Motion is enabled.

This package supports reveal-and-tap actions, rather than destructive full-swipe gestures.

## Examples

- `Examples/InboxExample.swift`: star and delete actions in an inbox.
- `Examples/TaskActionsExample.swift`: two trailing actions and a custom threshold.

## Tests

Gesture computations are isolated in `SwipeRevealLogic`. Run `swift test` to test direction detection, clamping, thresholds and reverse swipes.

## License

MIT. See [LICENSE](LICENSE).

Created by **Niloufar Rabiee**.
