import SwiftUI

struct MiniPlayerView: View {
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
        .contentShape(.rect)
    }
    
    @ViewBuilder private func MiniPlayerLHSView() -> some View {
        HStack(spacing: 12) {
            EmptyCoverView(of: size, with: .caption, of: size.width / 4, with: Color("AppDarkGrayColor"))
            
            VStack(alignment: .leading, spacing: 2) {
                if let song = audioViewModel.currentSong {
                    Text(song.title == "No title provided" ? song.fileName?.removeFileExtension ?? "Weird file name" : song.title)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .font(.callout)
                    
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
