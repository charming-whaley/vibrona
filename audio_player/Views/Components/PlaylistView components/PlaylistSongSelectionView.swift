import SwiftUI
import SwiftData

struct PlaylistSongSelectionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Song.dateAdded) var songs: [Song]
    
    @Bindable var playlist: Playlist
    @State private var searchQuery: String = ""
    
    private var processedSongsList: [Song] {
        return DataController.shared.retrieveProcessedSongsList(of: songs, by: searchQuery)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if songs.isEmpty {
                    NoSongsView()
                } else {
                    PlaylistSongSelectionContentView()
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
    
    @ViewBuilder private func PlaylistSongSelectionContentView() -> some View {
        SongsCollectionView(padding: .zero) {
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

#Preview {
    let preview = PreviewContainer(Song.self)
    preview.insert(Song.songs)
    
    return PlaylistSongSelectionView(playlist: .init(title: "Hello"))
        .preferredColorScheme(.dark)
        .modelContainer(preview.container)
}
