import SwiftUI

struct MiniPlaylistItemView: View {
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

#Preview {
    MiniPlaylistItemView(playlist: Playlist(title: "Starboy"))
        .preferredColorScheme(.dark)
}
