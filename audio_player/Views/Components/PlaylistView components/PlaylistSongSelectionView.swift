import SwiftUI
import SwiftData

struct PlaylistSongSelectionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Song.dateAdded) var songs: [Song]
    
    @Bindable var playlist: Playlist
    @State private var searchQuery: String = ""
    
    var processedSongsList: [Song] {
        var filteredSongsList = [Song]()
        if searchQuery.isEmpty {
            filteredSongsList = songs
        } else {
            filteredSongsList = songs.filter { song in
                song.title.localizedStandardContains(searchQuery) || song.artist.localizedStandardContains(searchQuery) || searchQuery.isEmpty
            }
        }
        
        return filteredSongsList
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if songs.isEmpty {
                    NoSongsView()
                } else {
                    ScrollView(.vertical) {
                        LazyVStack {
                            ForEach(processedSongsList) { song in
                                SongItemView(song: song) {
                                    Button {
                                        if let index = playlist.songs.firstIndex(where: { $0.id == song.id }) {
                                            playlist.songs.remove(at: index)
                                        } else {
                                            playlist.songs.append(song)
                                        }
                                        
                                        do {
                                            try modelContext.save()
                                        } catch {
                                            print("[Fatal error]: couldn't update the model context due to:\n\n\(error)")
                                        }
                                    } label: {
                                        Image(systemName: playlist.songs.contains(where: { $0.id == song.id }) ? "plus.circle.fill" : "plus.circle")
                                            .font(.system(size: 20))
                                            .foregroundStyle(.white)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchQuery, prompt: Text("Search songs..."))
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    let preview = PreviewContainer(Song.self)
    preview.insert(Song.songs)
    
    return PlaylistSongSelectionView(playlist: .init(title: "Hello"))
        .preferredColorScheme(.dark)
        .modelContainer(preview.container)
}
