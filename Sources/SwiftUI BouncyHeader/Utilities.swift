import SwiftUI

final class ViewFrame: ObservableObject {
    private(set) var startingRect: CGRect?

    @Published var frame: CGRect = .zero {
        willSet {
            if startingRect == nil {
                startingRect = newValue
            }
        }
    }
}

struct GeometryGetter: View {
    @Binding private(set) var rect: CGRect

    var body: some View {
        GeometryReader {
            Color.clear.preference(key: RectanglePreferenceKey.self, value: $0.frame(in: .global))
        }
        .onPreferenceChange(RectanglePreferenceKey.self) {
            rect = $0
        }
    }
}

struct RectanglePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
