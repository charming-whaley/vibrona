import SwiftUI
import AVFoundation
import Observation

@Observable
final class AudioViewModel : NSObject, AVAudioPlayerDelegate {
    var currentSong: Song?
    var isPlaying: Bool = false
    var isSeeking: Bool = false
    var isRepeating: Bool = false
    var isShuffled: Bool = false
    var currentDurationPosition: Double = 0
    
    var playbackQueueBeforeShuffling = [Song]()
    var playbackQueueAfterShuffling = [Song]()
    
    private var player: AVAudioPlayer?
    private var timer: Timer?
    
    func play(song: Song) {
        stop()
        self.currentSong = song
        
        if !checkIfSongBelongsToPlaybackQueue(song: song) {
            addToPlaybackQueue(song: song)
        }
        
        guard let url = song.url else {
            print("[Fatal error]: couldn't retrieve song's url")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
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
    
    func toggleRepeat() {
        isRepeating.toggle()
        player?.numberOfLoops = isPlaying ? -1 : 0
    }
    
    func seek(to time: Double) {
        player?.currentTime = time
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
    
    func updateProgress() {
        guard let player = player, !isSeeking else {
            return
        }
        
        currentDurationPosition = player.currentTime
    }
    
    func addToPlaybackQueue(song: Song) {
        if !playbackQueueBeforeShuffling.contains(song) {
            playbackQueueBeforeShuffling.append(song)
            
            if isShuffled {
                let index = playbackQueueAfterShuffling.isEmpty ? 0 : Int.random(in: 1..<playbackQueueAfterShuffling.count + 1)
                playbackQueueAfterShuffling.insert(song, at: index)
            } else {
                playbackQueueAfterShuffling.append(song)
            }
        }
    }
    
    func checkIfSongBelongsToPlaybackQueue(song: Song) -> Bool {
        return playbackQueueBeforeShuffling.contains(song)
    }
    
    func removeFromPlaybackQueue(song: Song) {
        playbackQueueAfterShuffling.removeAll(where: { $0 == song })
        playbackQueueBeforeShuffling.removeAll(where: { $0 == song })
    }
    
    func shuffle() {
        isShuffled.toggle()
        
        guard
            let currentSong = currentSong,
            let currentSongIndex = playbackQueueAfterShuffling.firstIndex(of: currentSong)
        else {
            playbackQueueAfterShuffling = isShuffled ? playbackQueueBeforeShuffling.shuffled() : playbackQueueBeforeShuffling
            return
        }
        
        if isShuffled {
            var temporaryPlaybackQueue = playbackQueueAfterShuffling
            temporaryPlaybackQueue.remove(at: currentSongIndex)
            temporaryPlaybackQueue.shuffle()
            playbackQueueAfterShuffling = [currentSong] + temporaryPlaybackQueue
        } else {
            playbackQueueAfterShuffling = playbackQueueBeforeShuffling
        }
    }
    
    func playNextSongInPlaybackQueue() {
        guard !playbackQueueAfterShuffling.isEmpty else {
            return
        }
        
        if let currentSong = currentSong,
           let currentSongIndex = playbackQueueAfterShuffling.firstIndex(of: currentSong) {
            let next = (currentSongIndex + 1) % playbackQueueAfterShuffling.count
            play(song: playbackQueueAfterShuffling[next])
        } else {
            if let firstSong = playbackQueueAfterShuffling.first {
                play(song: firstSong)
            }
        }
    }
    
    func playPreviousSongInPlaybackQueue() {
        guard !playbackQueueAfterShuffling.isEmpty else {
            return
        }
        
        if let currentSong = currentSong,
           let currentSongIndex = playbackQueueAfterShuffling.firstIndex(of: currentSong) {
            let previous = (currentSongIndex - 1 + playbackQueueAfterShuffling.count) % playbackQueueAfterShuffling.count
            play(song: playbackQueueAfterShuffling[previous])
        } else {
            if let lastSong = playbackQueueAfterShuffling.last {
                play(song: lastSong)
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
    
    private func playSongInPlaybackQueue() {
        guard !playbackQueueAfterShuffling.isEmpty else {
            stop()
            currentSong = nil
            return
        }
        
        if let currentSong = currentSong,
           let currentSongIndex = playbackQueueAfterShuffling.firstIndex(of: currentSong) {
            let next = (currentSongIndex + 1) % playbackQueueAfterShuffling.count
            play(song: playbackQueueAfterShuffling[next])
        } else {
            if let firstSong = playbackQueueAfterShuffling.first {
                play(song: firstSong)
            }
        }
    }
}
