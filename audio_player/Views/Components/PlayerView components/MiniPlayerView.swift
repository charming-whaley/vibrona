import SwiftUI
import MarqueeText

struct MiniPlayerView: View {
    var velocity: CGFloat = 50
    @Bindable var audioViewModel: AudioViewModel
    let size: CGSize = .init(width: 32, height: 32)
    
    var body: some View {
        HStack(spacing: 15) {
            MiniPlayerLHSView()
            
            Spacer()
            
            Button {
                audioViewModel.toggle()
            } label: {
                Image(systemName: audioViewModel.isPlaying ? "pause.fill" : "play.fill")
                    .contentShape(.rect)
                    .foregroundStyle(.foreground)
            }
            .padding(.trailing, 10)
        }
        .padding(.horizontal)
        .background(SongBackgroundFadeView(
            image: audioViewModel.currentSong?.cover,
            topPadding: -45,
            bottomPadding: -16
        ))
        .ignoresSafeArea()
        .contentShape(.rect)
        .overlay {
            Group {
                if let currentSong = audioViewModel.currentSong, let duration = currentSong.duration {
                    MiniPlayerProgressBarView(audioViewModel: audioViewModel, range: 0...duration)
                }
            }
            .padding(.top, 45)
        }
    }
    
    @ViewBuilder private func MiniPlayerLHSView() -> some View {
        HStack(spacing: 12) {
            EmptyCoverView(of: size, with: .caption, of: size.width / 4, with: Color("AppDarkGrayColor"))
            
            VStack(alignment: .leading, spacing: 2) {
                if let song = audioViewModel.currentSong {
                    MarqueeText(
                        text: song.title == "No title provided" ? song.fileName?.removeFileExtension ?? "Weird file name" : song.title,
                        font: UIFont.preferredFont(forTextStyle: .callout),
                        leftFade: 16,
                        rightFade: 16,
                        startDelay: 3
                    )
                    
                    Text(song.artist)
                        .font(.caption2)
                        .foregroundStyle(.gray)
                } else {
                    Text("Empty title")
                        .font(.callout)
                    
                    Text("Unknown")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                }
            }
        }
    }
}

#Preview {
    MiniPlayerView(audioViewModel: AudioViewModel())
        .preferredColorScheme(.dark)
}
