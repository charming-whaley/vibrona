import SwiftUI

struct SongItemView<Actions>: View where Actions: View {
    var song: Song
    var size: CGSize
    var actions: Actions
    
    init(song: Song, size: CGSize = .init(width: 35, height: 35), actions: @escaping () -> Actions) {
        self.song = song
        self.size = size
        self.actions = actions()
    }
    
    var body: some View {
        HStack(spacing: 15) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: size.height / 4)
                    .fill(.blue.gradient)
                    .frame(width: size.width, height: size.height)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(song.title)
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    Text("\(song.artist)")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
            
            Spacer()
            
            actions
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
    SongItemView(song: .init(title: "Welcome to New York", artist: "Taylor Swift", filePath: "")) {
        VStack {  }
    }
    .preferredColorScheme(.dark)
}
