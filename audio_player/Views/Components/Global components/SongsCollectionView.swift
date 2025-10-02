import SwiftUI

struct SongsCollectionView<Content>: View where Content: View {
    var content: Content
    var edges: Edge.Set
    var padding: CGFloat
    
    init(edges: Edge.Set = [], padding: CGFloat = 15, content: @escaping () -> Content) {
        self.edges = edges
        self.padding = padding
        self.content = content()
    }
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                content
            }
        }
        .contentMargins(edges, padding)
    }
}
