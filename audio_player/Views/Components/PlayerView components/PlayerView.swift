import SwiftUI
import SwiftData

struct PlayerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AudioViewModel.self) var audioViewModel: AudioViewModel
    @Environment(\.dismiss) private var dismiss
    
    @Query private var playlists: [Playlist]
    
    @State private var currentSong: Song?
    @State private var savedInPlaylist: Bool = false
    private var isSongSavedToPlaylist: Bool {
        guard let currentSong = audioViewModel.currentSong else {
            return false
        }
        
        return playlists.contains { playlist in
            playlist.songs.contains { $0.persistentModelID == currentSong.persistentModelID }
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                HStack(spacing: 0) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.down")
                            .font(.title2)
                            .foregroundStyle(.foreground)
                    }
                    
                    Spacer()
                    
                    Menu {
                        Button {
                            
                        } label: {
                            Label("Hide song", systemImage: "xmark")
                        }
                        
                        Button {
                            currentSong = audioViewModel.currentSong
                        } label: {
                            Label("Add to Playlist", systemImage: "music.pages.fill")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.title2)
                            .foregroundStyle(.foreground)
                            .contentShape(.rect)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 50) {
                    if let song = audioViewModel.currentSong {
                        if let cover = song.cover {
                            Image(uiImage: cover)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: proxy.size.width, height: proxy.size.width)
                                .clipShape(.rect(cornerRadius: 15))
                        } else {
                            EmptyCoverView(of: .init(width: proxy.size.width, height: proxy.size.width), with: .system(size: 70))
                        }
                    } else {
                        EmptyCoverView(of: .init(width: proxy.size.width, height: proxy.size.width), with: .system(size: 70))
                    }
                    
                    VStack(spacing: 15) {
                        HStack(spacing: 0) {
                            VStack(alignment: .leading, spacing: 4) {
                                if let song = audioViewModel.currentSong {
                                    Text(song.title)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                        .font(.title3.bold())
                                        .foregroundStyle(.white)
                                    
                                    Text(song.artist)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(.secondary)
                                } else {
                                    Text("No title")
                                        .font(.title3.bold())
                                        .foregroundStyle(.white)
                                    
                                    Text("Unknown")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            Spacer()
                            
                            Button {
                                currentSong = audioViewModel.currentSong
                            } label: {
                                Image(systemName: isSongSavedToPlaylist ? "plus.circle.fill" : "plus.circle")
                                    .font(.title)
                                    .foregroundStyle(.white)
                            }
                        }
                        .padding(.bottom, 10)
                        
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 100)
                                .fill(.blue)
                                .frame(maxWidth: .infinity)
                                .frame(height: 4)
                            
                            HStack(spacing: 0) {
                                Text("0:00")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                Spacer()
                                
                                Text("0:00")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        HStack(spacing: 25) {
                            Button {
                                
                            } label: {
                                Image(systemName: "backward.fill")
                                    .font(.system(size: 30))
                                    .foregroundStyle(.white)
                            }
                            
                            ZStack(alignment: .center) {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 65, height: 65)
                                
                                Image(systemName: audioViewModel.isPlaying ? "pause.fill" : "play.fill")
                                    .font(.system(size: 35))
                                    .foregroundStyle(.black)
                            }
                            .onTapGesture {
                                audioViewModel.isPlaying.toggle()
                            }
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "forward.fill")
                                    .font(.system(size: 30))
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                }
                
                Spacer()
            }
        }
        .background(SongBackgroundFadeView(image: audioViewModel.currentSong?.cover))
        .padding(25)
        .sheet(item: $currentSong) { song in
            SongPlaylistSelectionView(song: song)
        }
    }
}

#Preview {
    PlayerView()
        .environment(AudioViewModel())
        .preferredColorScheme(.dark)
}
