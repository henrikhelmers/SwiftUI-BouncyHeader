import SwiftUI

public struct BouncyHeaderView<HeaderContent: View, HeaderCompressedContent: View, Content: View>: View {
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

    public var body: some View {
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

