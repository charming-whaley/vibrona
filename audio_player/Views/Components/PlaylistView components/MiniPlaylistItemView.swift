import SwiftUI

struct MiniPlaylistItemView: View {
    // @State private var widthSize: CGSize = .zero
    var playlist: Playlist
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 8) {
                if let coverData = playlist.coverData {
                    Image(uiImage: UIImage(data: coverData)!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: proxy.size.width, height: 160)
                        .clipShape(.rect(cornerRadius: 12))
                } else {
                    EmptyCoverView(of: .init(width: proxy.size.width, height: 160), with: .largeTitle, of: 12)
                }
                
                Text(playlist.title)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
            }
        }
        .frame(height: 188)
    }
}

fileprivate struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

#Preview {
    MiniPlaylistItemView(playlist: Playlist(title: "Starboy"))
        .preferredColorScheme(.dark)
}
