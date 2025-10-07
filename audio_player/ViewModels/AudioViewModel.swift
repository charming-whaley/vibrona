import SwiftUI
import Observation

@Observable
final class AudioViewModel {
    var currentSong: Song?
    var isPlaying: Bool = false
    var currentDurationPosition: Double = 0
}
