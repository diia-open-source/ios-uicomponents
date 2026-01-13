
import UIKit
import Lottie
import AVKit

public final class DSVideoContainerViewModel {
    public let componentId: String?
    public let source: String
    public let playerBtnAtm: DSPlayerBtnModel?
    public let fullScreenVideoOrg: DSFullScreenVideoOrg?
    public let thumbnail: String?
    
    public var eventHandler: ((ConstructorItemEvent) -> Void)?
    
    public init(componentId: String?,
                source: String,
                playerBtnAtm: DSPlayerBtnModel?,
                fullScreenVideoOrg: DSFullScreenVideoOrg?,
                thumbnail: String?) {
        self.componentId = componentId
        self.source = source
        self.playerBtnAtm = playerBtnAtm
        self.fullScreenVideoOrg = fullScreenVideoOrg
        self.thumbnail = thumbnail
    }
    
    public init(videoData: DSVideoData) {
        self.componentId = videoData.componentId
        self.source = videoData.source
        self.playerBtnAtm = videoData.playerBtnAtm
        self.fullScreenVideoOrg = videoData.fullScreenVideoOrg
        self.thumbnail = videoData.thumbnail
    }
}

public final class DSVideoContainerView: BaseCodeView {
    private let container = UIView()
    private let thumbnailImageView = UIImageView()
    private let playerController = AVPlayerViewController()
    private let playButton = UIButton()
    
    private let audioSession = AVAudioSession.sharedInstance()

    private var isPlaying = false
    private var videoWasStarted = false
    private var observations: [NSKeyValueObservation] = []
    
    private var viewModel: DSVideoContainerViewModel?
    
    override public func setupSubviews() {
        addSubview(container)
        container.fillSuperview()
        container.heightAnchor.constraint(equalTo: container.widthAnchor,
                                          multiplier: Constants.containerMultiplier).isActive = true
        
        playerController.player = AVPlayer()
        playerController.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerController.showsPlaybackControls = false
        
        container.addSubview(playerController.view)
        playerController.view.fillSuperview()
        
        container.addSubview(thumbnailImageView)
        thumbnailImageView.fillSuperview()
        thumbnailImageView.isHidden = true
        
        container.addSubview(playButton)
        playButton.withSize(Constants.buttonSize)
        playButton.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        setupPlayButton()
        setupAcessibility()
        observations = [
            audioSession.observe(\.outputVolume, options: [.new]) { [weak self] _, _ in
                if self?.isPlaying == true {
                    try? self?.audioSession.setCategory(.playback)
                }
            }
        ]
    }
    
    deinit {
        if videoWasStarted {
            try? audioSession.setCategory(.soloAmbient)
        }
    }
    
    // MARK: - Setup
    public func configure(viewModel: DSVideoContainerViewModel) {
        self.viewModel = viewModel
        guard let videoURL = URL(string: viewModel.source) else { return }
        let asset = AVURLAsset(url: videoURL)
        let playerItem = AVPlayerItem(asset: asset)
        thumbnailImageView.loadImage(imageURL: viewModel.thumbnail,
                                     completion: {[weak self] in
            self?.thumbnailImageView.isHidden = false
        })
        playerController.player?.replaceCurrentItem(with: playerItem)
    }
    
    public func configure(data: DSVideoData) {
        configure(viewModel: DSVideoContainerViewModel(videoData: data))
    }
    
    private func setupPlayButton() {
        playButton.backgroundColor = .halfBlack
        playButton.setImage(R.image.play.image, for: .normal)
        playButton.imageView?.contentMode = .scaleAspectFit
        playButton.contentVerticalAlignment = .fill
        playButton.contentHorizontalAlignment = .fill
        playButton.imageEdgeInsets = Constants.imageInset
        playButton.layer.cornerRadius = Constants.cornerRadius
        playButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
    }
    
    @objc private func playVideo(_ sender: UIButton) {
        if let fullScreenVideoOrg = viewModel?.fullScreenVideoOrg {
            viewModel?.eventHandler?(.fullVideoAction(model: fullScreenVideoOrg))
            return
        }
        videoWasStarted = true
        isPlaying.toggle()
        
        if isPlaying {
            sender.isHidden = true
            playerController.showsPlaybackControls = true
            playerController.player?.play()
        } else {
            sender.isHidden = false
            playerController.showsPlaybackControls = false
            playerController.player?.pause()
        }
    }
    
    // MARK: - Accessibility
    private func setupAcessibility() {
        playButton.isAccessibilityElement = true
        playButton.accessibilityTraits = .button
        playButton.accessibilityLabel = R.Strings.recruitment_accessibility_video_play_button.localized()
    }
}

extension DSVideoContainerView {
    enum Constants {
        static let containerMultiplier: CGFloat = 9/16
        static let buttonSize = CGSize(width: 64, height: 64)
        static let imageInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        static let cornerRadius: CGFloat = 16
    }
}
