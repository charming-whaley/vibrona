import SwiftUI
import SwiftData

struct PlaylistsListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var addNewPlaylist: Bool = false
    @Query var playlists: [Playlist]
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)], spacing: 15) {
                    ForEach(playlists) { playlist in
                        NavigationLink {
                            // Navigation to songs list
                        } label: {
                            MiniPlaylistItemView(item: playlist)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .contentMargins([.top, .bottom], 15)
            .navigationTitle("Playlists")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $addNewPlaylist) {
                
            }
        }
    }
}

#Preview {
    let preview = PreviewContainer(Playlist.self)
    preview.insert(Playlist.playlists)
    
    return PlaylistsListView()
        .preferredColorScheme(.dark)
        .modelContainer(preview.container)
}
