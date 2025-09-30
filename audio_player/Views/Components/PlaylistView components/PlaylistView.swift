import SwiftUI

struct PlaylistView: View {
    let playlist: Playlist
    
    var body: some View {
        VStack {
            Text(playlist.title)
        }
    }
}

#Preview {
    PlaylistView(playlist: .init(title: "Some funny playlist"))
}
