import SwiftUI

struct PlaylistBackgroundFadeView: View {
    let image: UIImage?
    @Binding var topInset: CGFloat
    @Binding var scrollOffsetY: CGFloat
    
    var body: some View {
        if let image = image {
            GeometryReader { proxy in
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .clipped()
                }
                .compositingGroup()
                .blur(radius: 30, opaque: true)
                .overlay {
                    Rectangle()
                        .fill(.black.opacity(0.35))
                }
                .mask {
                    Rectangle()
                        .fill(.linearGradient(
                            colors: [.black, .black, .black, .black, .black.opacity(0.5), .clear],
                            startPoint: .top,
                            endPoint: .bottom)
                        )
                }
            }
            .containerRelativeFrame(.horizontal)
            .padding(.bottom, -60)
            .padding(.top, -topInset)
            .offset(y: scrollOffsetY < 0 ? scrollOffsetY : 0)
        } else {
            EmptyView()
        }
    }
}

#Preview {
    PlaylistBackgroundFadeView(image: nil, topInset: .constant(0), scrollOffsetY: .constant(0))
}
