
import UIKit
import Foundation
import Lottie
import AVKit
import DiiaCommonTypes

/// design_system_code: loopingVideoPlayerCardMlc

public struct DSLoopingVideoCardMlc: Codable {
    public let componentId: String?
    public let video: String
    public let label: String
    public let iconRight: String
    public let action: DSActionParameter?
    
    public init(componentId: String?, video: String, label: String, iconRight: String, action: DSActionParameter?) {
        self.componentId = componentId
        self.video = video
        self.label = label
        self.iconRight = iconRight
        self.action = action
    }
}

final public class DSLoopingVideoCardView: BaseCodeView {
    private let playerController = AVPlayerViewController()
    private let detailsLabel = UILabel().withParameters(font: FontBook.bigText, textColor: .white)
    private let arrowIconView = UIImageView()
    
    private var touchAction: Callback?
    private var imagePlaceholder = LottieAnimationView.loadingPlaceholder()
    private var statusObserver: NSKeyValueObservation?
    
    // MARK: - Life cycle
    override public func setupSubviews() {
        playerController.player = AVPlayer()
        
        let bottomViewContainer = UIView()
        bottomViewContainer.backgroundColor = .halfBlack
        bottomViewContainer.hstack(
            detailsLabel, arrowIconView,
            alignment: .center,
            padding: Constants.bottomViewInsets)
        
        playerController.showsPlaybackControls = false
        addSubview(playerController.view)
        addSubview(bottomViewContainer)
        addSubview(imagePlaceholder)
        
        self.withHeight(Constants.viewHeight)
        arrowIconView.withSize(Constants.iconSize)
        playerController.view.fillSuperview()
        
        imagePlaceholder.withSize(Constants.placeholderSize)
        imagePlaceholder.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imagePlaceholder.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imagePlaceholder.play()
        
        bottomViewContainer.anchor(
            leading: playerController.view.leadingAnchor,
            bottom: playerController.view.bottomAnchor,
            trailing: playerController.view.trailingAnchor)
        
        setupUI()
        addTapGestureRecognizer()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if self.playerController.player?.isPlaying == false {
            self.playerController.player?.play()
        }
    }
    
    // MARK: - Public Methods
    public func configure(with model: DSLoopingVideoCardMlc, touchAction: Callback?) {
        self.accessibilityIdentifier = model.componentId
        self.touchAction = touchAction
        detailsLabel.text = model.label
        arrowIconView.image = UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: model.iconRight)
        
        guard let videoURL = URL(string: model.video) else { return }
        setupVideo(from: videoURL)
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: self.playerController.player?.currentItem,
            queue: .main) { [weak self] _ in
                self?.playerController.player?.seek(to: CMTime.zero)
                self?.playerController.player?.play()
            }
        try? AVAudioSession.sharedInstance().setActive(false)
        try? AVAudioSession.sharedInstance().setCategory(.soloAmbient)
        
        statusObserver = playerController.player?.currentItem?.observe(
            \.status,
             options: [.new, .initial]) { [weak self] item, _ in
            if self?.playerController.player?.isPlaying == true {
                self?.imagePlaceholder.stop()
                self?.imagePlaceholder.isHidden = true
            }
        }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = Constants.backgroundColor
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true
    }
    
    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    private func changePlaying(isPlaying: Bool) {
        if isPlaying {
            playerController.player?.play()
        } else {
            playerController.player?.pause()
        }
    }
    
    private func setupVideo(from videoURL: URL) {
        let playerItem = AVPlayerItem(url: videoURL)
        playerController.player?.replaceCurrentItem(with: playerItem)
        playerController.player?.seek(to: .zero)
        playerController.player?.play()
        playerController.videoGravity = .resizeAspectFill
    }
    
    // MARK: - Actions
    @objc private func onClick() {
        touchAction?()
    }
}

extension DSLoopingVideoCardView: ScrollDependentComponentProtocol {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        changePlaying(isPlaying: scrollView.bounds.contains(self.frame))
    }
}

private extension DSLoopingVideoCardView {
    enum Constants {
        static let backgroundColor = UIColor("#1E1E1E")
        static let viewHeight: CGFloat = 200
        static let spacing: CGFloat = 8
        static let cornerRadius: CGFloat = 16
        static let bottomViewInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let iconSize = CGSize(width: 24, height: 24)
        static let placeholderSize = CGSize(width: 60, height: 60)
    }
}
