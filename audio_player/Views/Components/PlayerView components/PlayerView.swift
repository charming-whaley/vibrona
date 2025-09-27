import SwiftUI

struct PlayerView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
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
                
                Button {
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title2)
                        .foregroundStyle(.foreground)
                }
            }
            
            HStack(spacing: 25) {
                Button {
                    
                } label: {
                    Image(systemName: "backward.end.fill")
                        .font(.title)
                        .foregroundStyle(.foreground)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "play.fill")
                        .font(.title)
                        .foregroundStyle(.foreground)
                        .padding(20)
                        .background {
                            Circle()
                                .fill(.blue)
                        }
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "forward.end.fill")
                        .font(.title)
                        .foregroundStyle(.foreground)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    PlayerView()
}
