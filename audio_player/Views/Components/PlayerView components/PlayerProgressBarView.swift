import SwiftUI

struct PlayerProgressBarView: View {
    @Binding var currentDurationPosition: Double
    @State private var isDragging: Bool = false
    
    let duration: Double
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.secondary.opacity(0.3))
                    .frame(height: 8)
                
                Capsule()
                    .fill(Color.white)
                    .frame(width: proxy.size.width * CGFloat(currentDurationPosition / duration), height: 8)
                
                Capsule()
                    .fill(Color.white)
                    .frame(width: 18, height: 18)
                    .shadow(radius: 4)
                    .offset(x: currentDurationPosition / duration - 9)
            }
            .frame(height: 18)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if !isDragging {
                            isDragging = true
                        }
                        
                        updatePosition(for: value.location.x, in: proxy.size.width)
                    }
                    .onEnded { _ in
                        isDragging = false
                    }
            )
        }
        .frame(height: 20)
    }
    
    private func updatePosition(for x: CGFloat, in totalWidth: CGFloat) {
        let newProgress = min(max(0, x / totalWidth), 1)
        currentDurationPosition = Double(newProgress) * duration
    }
}

#Preview {
    PlayerProgressBarView(currentDurationPosition: .constant(0), duration: 0)
}
