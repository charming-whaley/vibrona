import SwiftUI
import SwiftData

struct PlaylistSongSelectionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query var songs: [Song]
    
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
            LazyVStack {
                ForEach(processedSongsList) { song in
                    Button {
                        playlist.songs.append(song)
                        do {
                            try modelContext.save()
                        } catch {
                            print("[Fatal error]: couldn't update the model context due to:\n\n\(error)")
                        }
                    } label: {
                        SongItemView(song: song) {
                            Image(systemName: "plus.circle")
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
            .searchable(text: $searchQuery, prompt: Text("Search songs..."))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .destructive) {
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
