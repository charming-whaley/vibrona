import SwiftData

struct PreviewContainer {
    let container: ModelContainer
    
    init(_ models: any PersistentModel.Type...) {
        let schema = Schema(models)
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            self.container = try ModelContainer(for: schema, configurations: configuration)
        } catch {
            fatalError("[Fatal error]: \(error)")
        }
    }
    
    func insert(_ content: [any PersistentModel]) {
        Task { @MainActor in
            content.forEach { item in
                container.mainContext.insert(item)
            }
        }
    }
}
