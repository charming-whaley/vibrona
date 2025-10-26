import Foundation
import SwiftData

struct PersistanceController {
    static private var retrievePlaybackQueuesJSONURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("playbackQueues.json")
    }
    
    static func encodePlaybackQueues(
        playbackQueueBeforeShuffling: [PersistentIdentifier],
        playbackQueueAfterShuffling: [PersistentIdentifier]
    ) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode([
                "playbackQueueBeforeShuffling": playbackQueueBeforeShuffling,
                "playbackQueueAfterShuffling": playbackQueueAfterShuffling
            ])
            try data.write(to: retrievePlaybackQueuesJSONURL, options: .atomic)
        } catch {
            print("\(error)")
        }
    }
    
    static func decodePlaybackQueues() -> (playbackQueueBeforeShuffling: [PersistentIdentifier], playbackQueueAfterShuffling: [PersistentIdentifier]?) {
        guard let data = try? Data(contentsOf: retrievePlaybackQueuesJSONURL) else {
            return ([PersistentIdentifier](), nil)
        }
        
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode([String: [PersistentIdentifier]].self, from: data)
            
            if let playbackQueueBeforeShuffling = decodedData["playbackQueueBeforeShuffling"],
               let playbackQueueAfterShuffling = decodedData["playbackQueueAfterShuffling"] {
                return (playbackQueueBeforeShuffling, playbackQueueAfterShuffling)
            }
        } catch {
            print("\(error)")
        }
        
        return ([PersistentIdentifier](), nil)
    }
}
