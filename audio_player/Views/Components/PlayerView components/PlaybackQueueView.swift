import SwiftUI
import SwiftData

struct PlaybackQueueView<PlayerControls>: View where PlayerControls: View {
    @Environment(AudioViewModel.self) var audioViewModel: AudioViewModel
    
    var playerControls: PlayerControls
    
    var playbackQueue: [Song] {
        if audioViewModel.isShuffled {
            return audioViewModel.playbackQueueAfterShuffling
        }
        
        return audioViewModel.playbackQueueBeforeShuffling
    }
    
    init(playerControls: @escaping () -> PlayerControls) {
        self.playerControls = playerControls()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 0) {
                Text("Playing Next")
                    .fontWeight(.semibold)
                
                Spacer()
            }
            .padding(.top, 12)
            
            SongsCollectionView(removeScrollIndicators: true, padding: 0) {
                ForEach(playbackQueue) { song in
                    SongItemView(song: song, padding: 0) {
                        Image(systemName: "line.3.horizontal")
                            .font(.callout)
                            .foregroundStyle(.gray)
                            .contentShape(.rect)
                    }
                }
            }
            
            playerControls
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    let preview = PreviewContainer(Song.self)
    preview.insert(Song.songs)
    
    return PlaybackQueueView() {
        VStack {}
    }
    .preferredColorScheme(.dark)
    .modelContainer(preview.container)
    .environment(AudioViewModel())
}
