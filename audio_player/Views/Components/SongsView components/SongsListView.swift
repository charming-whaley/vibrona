import SwiftUI
import SwiftData

struct SongsListView: View {
    @Query var songs: [Song]
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(songs) { song in
                    Button {
                        
                    } label: {
                        SongItemView(song: song)
                    }
                }
            }
        }
    }
}

#Preview {
    let preview = PreviewContainer(Song.self)
    preview.insert(Song.songs)
    
    return SongsListView()
        .preferredColorScheme(.dark)
        .modelContainer(preview.container)
}
