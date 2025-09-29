import SwiftUI
import SwiftData

struct SongsListView: View {
    @Query var songs: [Song]
    
    init(songsSortOrder: SongSortOrder, searchQuery: String) {
        let sortDescriptors: [SortDescriptor<Song>] = switch songsSortOrder {
        case .title:
            [SortDescriptor(\Song.title)]
        case .artist:
            [SortDescriptor(\Song.artist)]
        case .dateAdded:
            [SortDescriptor(\Song.dateAdded)]
        case .playCount:
            [SortDescriptor(\Song.playCount)]
        }
        
        let predicate = #Predicate<Song> { song in
            return song.title.localizedStandardContains(searchQuery)
            || song.artist.localizedStandardContains(searchQuery)
            || searchQuery.isEmpty
        }
        
        _songs = Query(filter: predicate, sort: sortDescriptors)
    }
    
    var body: some View {
        Group {
            if songs.isEmpty {
                ContentUnavailableView("No Songs...", systemImage: "music.note.list")
            } else {
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
    }
}

#Preview {
    let preview = PreviewContainer(Song.self)
    preview.insert(Song.songs)
    
    return SongsListView(songsSortOrder: .title, searchQuery: "The Weeknd")
        .preferredColorScheme(.dark)
        .modelContainer(preview.container)
}
