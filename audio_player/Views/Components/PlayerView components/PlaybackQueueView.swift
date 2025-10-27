import SwiftUI
import SwiftData

struct PlaybackQueueView<ShuffleContent, PlayerControls>: View where ShuffleContent: View, PlayerControls: View {
    @Environment(AudioViewModel.self) var audioViewModel: AudioViewModel
    
    var shuffleContent: ShuffleContent
    var playerControls: PlayerControls
    
    var playbackQueue: [Song] {
        if audioViewModel.isShuffled {
            return audioViewModel.playbackQueueAfterShuffling
        }
        
        return audioViewModel.playbackQueueBeforeShuffling
    }
    
    init(shuffleContent: @escaping () -> ShuffleContent, playerControls: @escaping () -> PlayerControls) {
        self.shuffleContent = shuffleContent()
        self.playerControls = playerControls()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 0) {
                Text("Playing Next")
                    .fontWeight(.semibold)
                
                Spacer()
                
                shuffleContent
            }
            .padding(.horizontal)
            
            SongsCollectionView {
                ForEach(playbackQueue) { song in
                    SongItemView(song: song) {
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
        .background {
            Rectangle()
                .fill(.clear)
                .glassEffect(in: .rect)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    let preview = PreviewContainer(Song.self)
    preview.insert(Song.songs)
    
    return PlaybackQueueView() {
        Image(systemName: "chevron.down")
            .font(.title3)
            .foregroundStyle(.foreground)
    } playerControls: {
        VStack {}
    }
    .preferredColorScheme(.dark)
    .modelContainer(preview.container)
    .environment(AudioViewModel())
}
