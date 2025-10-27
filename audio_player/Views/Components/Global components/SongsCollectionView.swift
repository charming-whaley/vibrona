import SwiftUI

struct SongsCollectionView<Content>: View where Content: View {
    var content: Content
    var edges: Edge.Set
    var removeScrollIndicators: Bool
    var padding: CGFloat
    
    init(edges: Edge.Set = [], removeScrollIndicators: Bool = false, padding: CGFloat = 15, content: @escaping () -> Content) {
        self.edges = edges
        self.removeScrollIndicators = removeScrollIndicators
        self.padding = padding
        self.content = content()
    }
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                content
            }
        }
        .scrollIndicators(removeScrollIndicators ? .hidden : .visible)
        .contentMargins(edges, padding)
    }
}
