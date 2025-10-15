import SwiftUI

struct MiniPlayerProgressBarView: View {
    @Bindable var audioViewModel: AudioViewModel
    var range: ClosedRange<Double>
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 2)
                
                Capsule()
                    .fill(Color.blue)
                    .frame(width: proxy.size.width * CGFloat((audioViewModel.currentDurationPosition - range.lowerBound) / (range.upperBound - range.lowerBound)), height: 2)
            }
            .frame(height: 2)
        }
        .frame(height: 2)
    }
}
