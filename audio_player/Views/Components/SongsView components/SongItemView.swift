import SwiftUI

struct SongItemView: View {
    var song: Song
    var size: CGSize = .init(width: 35, height: 35)
    
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
            
            Menu {
                Button(role: .destructive) {
                    
                } label: {
                    Label("Delete", systemImage: "trash.fill")
                }
                
                Button {
                    
                } label: {
                    Label("Song details", systemImage: "info.circle")
                }
                
                Button {
                    
                } label: {
                    Label("Hide", systemImage: "eye.slash.fill")
                }
                
                Button {
                    
                } label: {
                    Label("Play next", systemImage: "play.fill")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .contentShape(.rect)
            }
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
    SongItemView(song: .init(title: "Welcome to New York", artist: "Taylor Swift", filePath: ""))
        .preferredColorScheme(.dark)
}
