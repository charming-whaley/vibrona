import SwiftUI

struct PlayerProgressBarView: View {
    @Bindable var audioViewModel: AudioViewModel
    var range: ClosedRange<Double>
    var onEditingChanged: (Bool) -> Void
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 8)
                
                Capsule()
                    .fill(Color.blue)
                    .frame(
                        width: proxy.size.width * CGFloat((audioViewModel.currentDurationPosition - range.lowerBound) / (range.upperBound - range.lowerBound)),
                        height: 8
                    )
                    
                Capsule()
                    .fill(Color.white)
                    .frame(width: 20, height: 20)
                    .shadow(radius: 5)
                    .offset(x: proxy.size.width * CGFloat((audioViewModel.currentDurationPosition - range.lowerBound) / (range.upperBound - range.lowerBound)) - 10)
            }
            .frame(height: 20)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        onEditingChanged(true)
                        let newPercentage = max(0, min(1, value.location.x / proxy.size.width))
                        audioViewModel.currentDurationPosition = (range.upperBound - range.lowerBound) * newPercentage + range.lowerBound
                    }
                    .onEnded { _ in
                        onEditingChanged(false)
                    }
            )
            
        }
        .frame(height: 20)
    }
}
