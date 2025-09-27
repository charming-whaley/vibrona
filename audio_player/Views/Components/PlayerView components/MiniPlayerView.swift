import SwiftUI

struct MiniPlayerView: View {
    let size: CGSize = .init(width: 30, height: 30)
    
    var body: some View {
        HStack(spacing: 15) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: size.height / 4)
                    .fill(.blue.gradient)
                    .frame(width: size.width, height: size.height)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Trash title")
                        .font(.callout)
                    
                    Text("Trash artist")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                }
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "play.fill")
                    .contentShape(.rect)
                    .foregroundStyle(.foreground)
            }
            .padding(.trailing, 10)
            
            Button {
                
            } label: {
                Image(systemName: "forward.fill")
                    .contentShape(.rect)
                    .foregroundStyle(.foreground)
            }
        }
        .padding()
        .glassEffect(.clear)
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: [.red, .blue], startPoint: .leading, endPoint: .bottomTrailing)
        MiniPlayerView()
    }
}
