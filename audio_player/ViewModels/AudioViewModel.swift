import SwiftUI
import AVFoundation
import Observation

@Observable
final class AudioViewModel : NSObject, AVAudioPlayerDelegate {
    var currentSong: Song?
    var isPlaying: Bool = false
    var isSeeking: Bool = false
    var isRepeating: Bool = false
    var currentDurationPosition: Double = 0
    var playbackQueue = [Song]()
    
    private var player: AVAudioPlayer?
    private var timer: Timer?
    
    func play(song: Song) {
        stop()
        self.currentSong = song
        
        guard let url = song.url else {
            print("[Fatal error]: couldn't retrieve song's url")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = isRepeating ? -1 : 0
            player?.prepareToPlay()
            player?.play()
            
            self.isPlaying = true
            startTimer()
        } catch {
            print("[Fatal error]: couldn't load audio:\n\n\(error)")
            self.isPlaying = false
        }
    }
    
    func stop() {
        player?.stop()
        isPlaying = false
        stopTimer()
    }
    
    func toggle() {
        guard player != nil else {
            return
        }
        
        if isPlaying {
            player?.pause()
            isPlaying = false
            stopTimer()
        } else {
            player?.play()
            isPlaying = true
            startTimer()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
            self?.updateProgress()
        })
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func toggleRepeat() {
        isRepeating.toggle()
        player?.numberOfLoops = isPlaying ? -1 : 0
    }
    
    func seek(to time: Double) {
        player?.currentTime = time
    }
    
    func updateProgress() {
        guard let player = player, !isSeeking else {
            return
        }
        
        currentDurationPosition = player.currentTime
    }
    
    func addToPlaybackQueue(song: Song) {
        if !checkIfSongBelongsToPlaybackQueue(song: song) {
            playbackQueue.append(song)
        }
    }
    
    func checkIfSongBelongsToPlaybackQueue(song: Song) -> Bool {
        return playbackQueue.contains(song)
    }
    
    func removeFromPlaybackQueue(song: Song) {
        playbackQueue.removeAll(where: { $0 == song })
    }
    
    private func playNextSongInPlaybackQueue() {
        guard !playbackQueue.isEmpty else {
            stop()
            currentSong = nil
            return
        }
        
        if let currentSong = currentSong,
           let currentIndex = playbackQueue.firstIndex(of: currentSong) {
            let next = (currentIndex + 1) % playbackQueue.count
            play(song: playbackQueue[next])
        } else {
            if let firstSong = playbackQueue.first {
                play(song: firstSong)
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        guard !flag else {
            return
        }
        
        if !isRepeating {
            playNextSongInPlaybackQueue()
        }
    }
}
