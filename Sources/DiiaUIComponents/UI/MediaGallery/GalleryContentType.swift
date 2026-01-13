
import UIKit
import DiiaCommonTypes

public enum GalleryContentType {
    case image(viewModel: GalleryImageViewModel)
    case video(viewModel: GalleryVideoViewModel)
}

public final class GalleryVideoViewModel {
    let streamLink: String?
    let downloadLink: String
    let localFilename: String
    var localFileURL: URL?
    var preparePlaying: (() -> Void)?
    var actions: [Action] = []
    var state: Observable<VideoPlayingState> = .init(value: .loading)

    init(streamLink: String?,
         downloadLink: String
    ) {
        self.streamLink = streamLink
        self.downloadLink = downloadLink
        self.localFilename = "video_\(downloadLink.components(separatedBy: "/").last ?? "")"
    }
}

public enum VideoPlayingState {
    case loading
    case error(message: String)
    case readyForLoading(url: URL)
    case readyForPlaying(url: URL)
}

public final class GalleryImageViewModel {
    var image: UIImage?
    let imageLink: String?
    var actions: [Action] = []

    public init(imageLink: String?,
                image: UIImage?
    ) {
        self.imageLink = imageLink
        self.image = image
    }
}
