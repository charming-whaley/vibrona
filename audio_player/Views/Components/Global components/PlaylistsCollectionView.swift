import SwiftUI

struct PlaylistsCollectionView<Content>: View where Content: View {
    var content: Content
    var columns: [GridItem]
    var edges: Edge.Set
    var padding: CGFloat
    
    init(columns: [GridItem], edges: Edge.Set, padding: CGFloat = 15, content: @escaping () -> Content) {
        self.columns = columns
        self.edges = edges
        self.padding = padding
        self.content = content()
    }
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, spacing: 15) {
                content
            }
            .padding(.horizontal)
        }
        .contentMargins(edges, padding)
    }
}
