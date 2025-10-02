import SwiftUI
import SwiftData

struct SongPlaylistSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Playlist.title) var playlists: [Playlist]
    
    @State private var searchQuery: String = ""
    
    let song: Song
    private let columns = [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)]
    var processedPlaylistsList: [Playlist] {
        var filteredPlaylistsList = [Playlist]()
        if searchQuery.isEmpty {
            filteredPlaylistsList = playlists
        } else {
            filteredPlaylistsList = playlists.filter { playlist in
                playlist.title.localizedStandardContains(searchQuery) || searchQuery.isEmpty
            }
        }
        
        return filteredPlaylistsList
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if processedPlaylistsList.isEmpty {
                    NoPlaylistsView()
                } else {
                    ScrollView(.vertical) {
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(processedPlaylistsList) { playlist in
                                MiniPlaylistItemView(item: playlist)
                                    .overlay(alignment: .center) {
                                        if song.playlists.contains(where: { $0.id == playlist.id }) {
                                            Image(systemName: "checkmark.seal.fill")
                                                .font(.system(size: 40))
                                                .foregroundStyle(.white)
                                                .padding(.bottom, 25)
                                        }
                                    }
                                    .onTapGesture {
                                        if let index = song.playlists.firstIndex(where: { $0.id == playlist.id }) {
                                            song.playlists.remove(at: index)
                                        } else {
                                            song.playlists.append(playlist)
                                        }
                                        
                                        do {
                                            try modelContext.save()
                                        } catch {
                                            print("[Fatal error]: couldn't update the model context due to:\n\n\(error)")
                                        }
                                    }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .searchable(text: $searchQuery, prompt: Text("Search playlists..."))
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
    let preview = PreviewContainer(Playlist.self)
    preview.insert(Playlist.playlists)
    
    return SongPlaylistSelectionView(song: Song(title: "", artist: "", filePath: ""))
        .preferredColorScheme(.dark)
        .modelContainer(preview.container)
}
