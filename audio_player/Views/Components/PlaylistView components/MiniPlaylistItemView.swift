import SwiftUI

struct MiniPlaylistItemView: View {
    @State private var widthSize: CGSize = .zero
    var item: Playlist
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            EmptyCoverView(
                of: .init(width: widthSize.width, height: 160),
                with: .largeTitle,
                of: 12
            )
            
            HStack {
                Text(item.title)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
            }
        }
        .frame(maxWidth: .infinity)
        .background {
            GeometryReader { proxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: proxy.size)
            }
        }
        .onPreferenceChange(SizePreferenceKey.self) { size in
            self.widthSize = size
        }
    }
}

fileprivate struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

#Preview {
    MiniPlaylistItemView(item: Playlist(title: "Starboy"))
        .preferredColorScheme(.dark)
}
