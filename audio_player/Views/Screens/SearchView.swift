import SwiftUI
import SwiftData

struct SearchView: View {
    @Query var playlists: [Playlist]
    @Query var songs: [Song]
    
    var body: some View {
        NavigationStack {
            
        }
    }
}

#Preview {
    let preview = PreviewContainer(Playlist.self, Song.self)
    preview.insert(Playlist.playlists)
    preview.insert(Song.songs)
    
    return SearchView()
        .modelContainer(preview.container)
}
