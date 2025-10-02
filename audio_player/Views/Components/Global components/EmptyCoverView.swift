import SwiftUI

struct EmptyCoverView: View {
    let size: CGSize
    let iconSize: Font
    let radius: CGFloat
    let backgroundColor: Color
    
    init(
        of size: CGSize = .init(width: 30, height: 30),
        with iconSize: Font = .caption,
        of radius: CGFloat = 15,
        with backgroundColor: Color = Color("AppDarkGrayColor")
    ) {
        self.size = size
        self.iconSize = iconSize
        self.radius = radius
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        Rectangle()
            .fill(backgroundColor)
            .clipShape(.rect(cornerRadius: radius))
            .frame(width: size.width, height: size.height)
            .overlay(alignment: .center) {
                Image(systemName: "music.note")
                    .font(iconSize)
                    .foregroundStyle(.gray)
            }
    }
}

#Preview {
    EmptyCoverView()
}
