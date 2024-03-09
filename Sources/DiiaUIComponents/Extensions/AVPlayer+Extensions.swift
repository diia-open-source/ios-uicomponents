import AVKit

public extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
