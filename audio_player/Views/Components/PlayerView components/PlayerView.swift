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
                
                Menu {
                    Button {
                        
                    } label: {
                        Label("Share", systemImage: "square.and.arrow.up.fill")
                    }
                    
                    Button {
                        
                    } label: {
                        Label("Add to Liked", systemImage: "heart.fill")
                    }
                    
                    Button {
                        
                    } label: {
                        Label("Hide song", systemImage: "xmark")
                    }
                    
                    Button {
                        
                    } label: {
                        Label("Song details", systemImage: "info.bubble")
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
                EmptyCoverView(
                    of: .init(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.width - 50),
                    with: .system(size: 70)
                )
                
                VStack(spacing: 15) {
                    HStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Dummy song title")
                                .font(.title3.bold())
                                .foregroundStyle(.white)
                            
                            Text("Some dummy author")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "plus.circle")
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
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "play.fill")
                                .font(.system(size: 35))
                                .foregroundStyle(.black)
                                .padding()
                                .background {
                                    Circle()
                                        .fill(.white)
                                }
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
        .padding(25)
    }
}

#Preview {
    PlayerView()
        .preferredColorScheme(.dark)
}
