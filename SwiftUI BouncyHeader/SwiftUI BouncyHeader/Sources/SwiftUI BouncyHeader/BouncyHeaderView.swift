import SwiftUI

struct BouncyHeaderView<HeaderContent: View, HeaderCompressedContent: View, Content: View>: View {
    var idealHeight: CGFloat
    var minHeight: CGFloat
    var headerContent: HeaderContent?
    var headerCompressedContent: HeaderCompressedContent?
    var content: Content?

    @ObservedObject private var contentFrame: ViewFrame = ViewFrame()

    init(idealHeight: CGFloat = 400,
         minHeight: CGFloat = 110,
         @ViewBuilder headerContent: @escaping () -> HeaderContent,
         @ViewBuilder headerCompressedContent: @escaping () -> HeaderCompressedContent,
         @ViewBuilder content: @escaping () -> Content) {
        self.idealHeight = idealHeight
        self.minHeight = minHeight
        self.headerContent = headerContent()
        self.headerCompressedContent = headerCompressedContent()
        self.content = content()
    }

    var body: some View {
        ScrollView {
            content
                .offset(y: idealHeight)
                .background(GeometryGetter(rect: $contentFrame.frame))
            GeometryReader { geometry in
                Group {
                    if (getHeightForHeader(geometry) - 50) > minHeight {
                        headerContent
                    } else {
                        headerCompressedContent
                    }
                }
                .frame(height: getHeightForHeader(geometry))
                .offset(y: -geometry.frame(in: .global).minY)
            }
            .frame(height: idealHeight)
            .offset(y: -(contentFrame.startingRect?.maxY ?? 0))
        }
        .padding(.top, 10)
        .ignoresSafeArea(edges: .top)
    }

    private func getHeightForHeader(_ geometry: GeometryProxy) -> CGFloat {
        max(geometry.size.height + geometry.frame(in: .global).minY, minHeight)
    }
}

#Preview {
    BouncyHeaderView(headerContent: {
        Text("Large title")
            .font(.title)
    }, headerCompressedContent: {
        Text("Compressed title")
            .font(.title2)
    }, content: {
        Text(loremIpsum)
            .font(.title)
    })
}

final private class ViewFrame: ObservableObject {
    private(set) var startingRect: CGRect?

    @Published var frame: CGRect = .zero {
        willSet {
            if startingRect == nil {
                startingRect = newValue
            }
        }
    }
}

private struct GeometryGetter: View {
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

private struct RectanglePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
