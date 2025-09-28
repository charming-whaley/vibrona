import SwiftUI

struct MiniPlaylistItemView: View {
    var item: Playlist
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Rectangle()
                .fill(.white)
                .clipShape(.rect(cornerRadius: 12))
                .frame(height: 160)
            
            HStack {
                Text(item.title)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    MiniPlaylistItemView(item: Playlist(title: "Starboy"))
        .preferredColorScheme(.dark)
}
