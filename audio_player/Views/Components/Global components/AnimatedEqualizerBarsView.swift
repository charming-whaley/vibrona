import SwiftUI

struct AnimatedEqualizerBarsView: View {
    @State private var isAnimating: Bool = false
    var backgroundColor: Color = .white
    
    var body: some View {
        GeometryReader { proxy in
            let width = calculateBarWidth(in: proxy.size)
            let spacing = width * 0.2
            
            HStack(spacing: spacing) {
                ForEach(0..<5, id: \.self) { index in
                    BarShape(fraction: isAnimating ? 1 : 0.1)
                        .fill(backgroundColor)
                        .frame(width: width)
                        .animation(animate(at: index), value: isAnimating)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear(perform: { isAnimating.toggle() })
    }
    
    private func calculateBarWidth(in size: CGSize) -> CGFloat {
        let width = size.width / (CGFloat(5) + 0.2 * CGFloat(4))
        return width
    }
    
    private func animate(at index: Int) -> Animation {
        Animation
            .easeInOut(duration: Double.random(in: 0.6...1.2))
            .repeatForever(autoreverses: true)
            .delay(Double.random(in: 0...0.5))
    }
    
    private struct BarShape: Shape {
        var animatableData: CGFloat
        
        init(fraction: CGFloat) {
            self.animatableData = fraction
        }
        
        nonisolated func path(in rect: CGRect) -> Path {
            let minHeight = rect.height * 0.1
            let maxHeight = rect.height
            let currentHeight = minHeight + (maxHeight - minHeight) * animatableData
            
            var path = Path()
            path.addRect(CGRect(
                x: rect.minX,
                y: rect.maxY - currentHeight,
                width: rect.width,
                height: currentHeight
            ))
            return path
        }
    }
}

#Preview {
    return ZStack {
        Color.black.ignoresSafeArea()
        AnimatedEqualizerBarsView()
    }
}
