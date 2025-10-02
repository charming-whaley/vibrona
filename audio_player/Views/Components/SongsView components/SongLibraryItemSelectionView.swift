import SwiftUI
import SwiftData

struct SongLibraryItemSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Song.dateAdded) var songs: [Song]
    
    @State private var searchQuery: String = ""
    
    var libraryItem: LibraryItem
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
                    NoPlaylistsView()
                } else {
                    SongsCollectionView(padding: .zero) {
                        ForEach(processedSongsList) { song in
                            SongItemView(song: song) {
                                Button {
                                    if let index = libraryItem.songs?.firstIndex(where: { $0.id == song.id }) {
                                        libraryItem.songs?.remove(at: index)
                                    } else {
                                        libraryItem.songs?.append(song)
                                    }
                                    
                                    do {
                                        try modelContext.save()
                                    } catch {
                                        print("[Fatal error]: couldn't update the model context due to:\n\n\(error)")
                                    }
                                } label: {
                                    Image(systemName: libraryItem.songs?.contains(where: { $0.id == song.id }) ?? false ? "plus.circle.fill" : "plus.circle")
                                        .font(.system(size: 20))
                                        .foregroundStyle(.white)
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
