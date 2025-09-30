import SwiftUI
import SwiftData

struct PlaylistView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var songs: [Song]
    
    @State private var addsSongsToPlaylist: Bool = false
    
    let playlist: Playlist
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color("AppDarkGrayColor"))
                    .clipShape(.rect(cornerRadius: 12))
                    .frame(width: 300, height: 300)
                    .overlay(alignment: .center) {
                        Image(systemName: "music.note")
                            .font(.largeTitle)
                            .foregroundStyle(.gray)
                    }
                    .padding(16)
                
                Text(playlist.title)
                    .font(.title3.bold())
                    .padding(.bottom, 12)
                
                Divider()
                
                Button {
                    addsSongsToPlaylist.toggle()
                } label: {
                    AddSongToPlaylistButtonView()
                }
                
                ForEach(playlist.songs) { song in
                    SongItemView(song: song)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .sheet(isPresented: $addsSongsToPlaylist) {
                VStack {
                    Text("Hello, people!!!")
                }
            }
        }
    }
    
    @ViewBuilder private func AddSongToPlaylistButtonView(_ size: CGSize = .init(width: 30, height: 30)) -> some View {
        HStack(spacing: 15) {
            HStack(spacing: 12) {
                Circle()
                    .frame(width: size.width, height: size.height)
                    .foregroundStyle(.gray)
                    .overlay(alignment: .center) {
                        Image(systemName: "plus")
                            .foregroundStyle(.white)
                    }
                
                Text("Add Songs")
                    .font(.headline)
                    .foregroundStyle(.white)
            }
            
            Spacer()
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("AppDarkGrayColor"))
        }
        .padding(.horizontal)
        .contentShape(.rect)
    }
}

#Preview {
    let preview = PreviewContainer(Song.self)
    preview.insert(Song.songs)
    
    return PlaylistView(playlist: .init(title: "Some funny playlist", details: "Some things rise very rich and strong men"))
        .preferredColorScheme(.dark)
        .modelContainer(preview.container)
}
