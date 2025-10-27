import SwiftUI
import SwiftData
import AVKit
import MarqueeText

struct PlayerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AudioViewModel.self) var audioViewModel: AudioViewModel
    @Environment(\.dismiss) private var dismiss
    
    @Query private var playlists: [Playlist]
    
    @State private var currentSong: Song?
    @State private var savedInPlaylist: Bool = false
    @State private var showsPlaybackQueue: Bool = false
    
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
                PlayerHeaderContentView()
                
                Spacer()
                
                if showsPlaybackQueue {
                    PlayerPlaybackQueueContentView(proxy)
                } else {
                    PlayerMainContentView(proxy)
                    
                    Spacer()
                }
            }
        }
        .background(SongBackgroundFadeView(image: audioViewModel.currentSong?.cover))
        .padding(25)
        .sheet(item: $currentSong) { song in
            SongPlaylistSelectionView(song: song)
        }
    }
    
    @ViewBuilder private func PlayerHeaderContentView() -> some View {
        HStack(spacing: 0) {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.down")
                    .font(.title2)
                    .foregroundStyle(.foreground)
            }
            
            Spacer()
            
            Button(action: { showsPlaybackQueue.toggle() }) {
                Image(systemName: "list.bullet")
                    .font(.title2)
                    .foregroundStyle(.foreground)
            }
        }
    }
    
    @ViewBuilder private func PlayerMainContentView(_ proxy: GeometryProxy) -> some View {
        VStack(spacing: 50) {
            if let song = audioViewModel.currentSong {
                if let image = song.cover {
                    Image(uiImage: image)
                } else {
                    EmptyCoverView(of: .init(width: proxy.size.width, height: proxy.size.width), with: .system(size: 70))
                }
            } else {
                EmptyCoverView(of: .init(width: proxy.size.width, height: proxy.size.width), with: .system(size: 70))
            }
            
            VStack(spacing: 15) {
                PlayerInformationContentView()
                PlayerControlsContentView()
            }
        }
    }
    
    @ViewBuilder private func PlayerPlaybackQueueContentView(_ proxy: GeometryProxy) -> some View {
        PlaybackQueueView {
            VStack(spacing: 15) {
                PlayerControlsContentView()
            }
        }
    }
    
    @ViewBuilder private func PlayerInformationContentView() -> some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                if let currentSong = audioViewModel.currentSong {
                    MarqueeText(
                        text: currentSong.title == "No title provided" ? currentSong.fileName?.removeFileExtension ?? "Weird file name" : currentSong.title,
                        font: UIFont.preferredFont(forTextStyle: .title3),
                        leftFade: 16,
                        rightFade: 16,
                        startDelay: 3
                    )
                    .bold()
                    .foregroundStyle(.white)
                        
                    
                    Text(currentSong.artist)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.secondary)
                } else {
                    Text("Empty title")
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                    
                    Text("Unknown artist")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            Button(action: { currentSong = audioViewModel.currentSong }) {
                Image(systemName: isSongSavedToPlaylist ? "plus.circle.fill" : "plus.circle")
                    .font(.title)
                    .foregroundStyle(.white)
            }
        }
        .padding(.bottom, 10)
    }
    
    @ViewBuilder private func PlayerControlsContentView() -> some View {
        VStack(spacing: 8) {
            if let currentSong = audioViewModel.currentSong, let duration = currentSong.duration {
                PlayerProgressBarView(audioViewModel: audioViewModel, range: 0...duration) { isEditing in
                    audioViewModel.isSeeking = isEditing
                    if !isEditing {
                        audioViewModel.seek(to: audioViewModel.currentDurationPosition)
                    }
                }
                
                HStack(spacing: 0) {
                    Text(audioViewModel.currentDurationPosition.asTime)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text(duration.asTime)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } else {
                RoundedRectangle(cornerRadius: 100)
                    .fill(Color.gray.opacity(0.7))
                    .frame(height: 6)
                
                HStack(spacing: 0) {
                    Text(audioViewModel.currentDurationPosition.asTime)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("0:00")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        
        HStack(spacing: 25) {
            Button {
                audioViewModel.playPreviousSongInPlaybackQueue()
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
                audioViewModel.toggle()
            }
            
            Button {
                audioViewModel.playNextSongInPlaybackQueue()
            } label: {
                Image(systemName: "forward.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(.white)
            }
        }
        .frame(maxWidth: .infinity)
        .overlay {
            HStack(spacing: 0) {
                PlayerControlButtonView(
                    systemName: "repeat",
                    activeSystemName: "repeat.1",
                    isActive: audioViewModel.isRepeating,
                    isDisabled: !audioViewModel.isPlaying,
                    action: { audioViewModel.toggleRepeat() }
                )
                
                Spacer()
                
                PlayerControlButtonView(
                    systemName: "shuffle",
                    isActive: audioViewModel.isShuffled,
                    isDisabled: audioViewModel.playbackQueueBeforeShuffling.count <= 2,
                    action: { audioViewModel.shuffle() }
                )
            }
        }
    }
}

#Preview {
    PlayerView()
        .environment(AudioViewModel())
        .preferredColorScheme(.dark)
}
