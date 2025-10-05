import SwiftUI
import SwiftData

struct SongPlaylistSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Playlist.title) var playlists: [Playlist]
    
    @State private var searchQuery: String = ""
    
    let song: Song
    private let columns = [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)]
    private var processedPlaylistsList: [Playlist] {
        return DataController.shared.retrieveProcessedPlaylistsList(of: playlists, by: searchQuery)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if processedPlaylistsList.isEmpty {
                    NoPlaylistsView()
                } else {
                    SongPlaylistSelectionContentView()
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
    
    @ViewBuilder private func SongPlaylistSelectionContentView() -> some View {
        PlaylistsCollectionView(columns: columns, padding: .zero) {
            ForEach(processedPlaylistsList) { playlist in
                MiniPlaylistItemView(playlist: playlist)
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
}

#Preview {
    let preview = PreviewContainer(Playlist.self)
    preview.insert(Playlist.playlists)
    
    return SongPlaylistSelectionView(song: Song(title: "", artist: "", filePath: ""))
        .preferredColorScheme(.dark)
        .modelContainer(preview.container)
}
