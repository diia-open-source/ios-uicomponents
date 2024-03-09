import UIKit
import AVKit
import DiiaCommonTypes

class MediaGalleryVideoCell: UICollectionViewCell, Reusable {
    private let container = UIView()
    private let avPlayerVC = AVPlayerViewController()
    private let loadingImageView = UIImageView()
    private let actionStack = UIStackView()
    private let controlView = VideoControlsView()
    private let errorLabel = UILabel()
        .withParameters(font: FontBook.usualFont,
                        textColor: .white)
    private let audioSession = AVAudioSession.sharedInstance()

    private var viewModel: GalleryVideoViewModel?
    private var canPlaying = false
    private var needsToPlay = true

    private var hidingControlsWorkItem: DispatchWorkItem?

    // MARK: - Setup
    override init(frame: CGRect) {
        super.init(frame: frame)

        avPlayerVC.player = AVPlayer()

        contentView.addSubview(container)
        container.fillSuperview()
        container.addSubview(avPlayerVC.view)
        avPlayerVC.view.fillSuperview()
        container.addSubview(controlView)
        controlView.fillSuperview()
        container.addSubview(loadingImageView)
        loadingImageView.withSize(.init(width: 48, height: 48))
        loadingImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        loadingImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true

        loadingImageView.image = R.image.loading.image
        container.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        errorLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        errorLabel.widthAnchor.constraint(lessThanOrEqualTo: container.widthAnchor, constant: -20).isActive = true
        
        container.addSubview(actionStack)
        actionStack.anchor(top: container.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: container.safeAreaLayoutGuide.trailingAnchor)

        avPlayerVC.showsPlaybackControls = false
        errorLabel.isHidden = true
        loadingImageView.isHidden = true
        controlView.delegate = self
        setupObservations()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupObservations() {
        avPlayerVC.player?.addPeriodicTimeObserver(
            forInterval: CMTimeMakeWithSeconds(1.0 / 24.0, preferredTimescale: Int32(NSEC_PER_SEC)),
            queue: .main,
            using: { [weak self] (progressTime) in
                guard let self = self,
                      let duration = self.avPlayerVC.player?.currentItem?.duration
                else { return }
                let totalSeconds = CMTimeGetSeconds(duration)
                guard !(totalSeconds.isNaN || totalSeconds.isInfinite) else { return }
                let seconds = CMTimeGetSeconds(progressTime)
                self.controlView.setCurrentTime(currentTime: self.stringDuration(duration: seconds))
                self.controlView.setDuration(duration: self.stringDuration(duration: totalSeconds))
                self.controlView.updateProgress(progress: Float(seconds / CMTimeGetSeconds(duration)))
            }
        )
        let handleTapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(handleTapOnVideoView))
        container.addGestureRecognizer(handleTapGestureRecogniser)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleInterruption(notification:)),
            name: AVAudioSession.interruptionNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidReachEnd(notification:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: avPlayerVC.player?.currentItem)
    }

    override func prepareForReuse() {
        clearCell()
        super.prepareForReuse()
    }
    
    func clearCell() {
        viewModel?.state.removeObserver(observer: self)
        viewModel = nil
        canPlaying = false
        needsToPlay = false
        avPlayerVC.player?.pause()
        avPlayerVC.player?.replaceCurrentItem(with: nil)
    }

    func setVideo(viewModel: GalleryVideoViewModel) {
        self.viewModel = viewModel
        viewModel.state.observe(observer: self) { [weak self] state in
            switch state {
            case .loading:
                self?.controlView.isHidden = true
                self?.avPlayerVC.view.isHidden = true
                self?.actionStack.isHidden = true
                self?.changeLoading(isLoading: true)
                self?.errorLabel.isHidden = true
            case .error(let message):
                self?.avPlayerVC.view.isHidden = true
                self?.actionStack.isHidden = true
                self?.changeLoading(isLoading: false)
                self?.controlView.isHidden = true
                self?.errorLabel.isHidden = false
                self?.errorLabel.text = message
            case .readyForPlaying(let url):
                self?.avPlayerVC.view.isHidden = false
                self?.actionStack.isHidden = false
                self?.controlView.isHidden = false
                self?.changeLoading(isLoading: false)
                self?.errorLabel.isHidden = true
                self?.setup(url: url)
            }
        }
        updateActions(actions: viewModel.actions)
        viewModel.preparePlaying?()
    }

    func setNeedsToPlay() {
        if avPlayerVC.player?.isPlaying == true { return }
        needsToPlay = true
        playIfNeed()
    }

    // MARK: - Private
    private func updateActions(actions: [Action]) {
        actionStack.safelyRemoveArrangedSubviews()
        actionStack.isHidden = actions.count == 0
        actions.forEach { action in
            let action = Action(title: action.title, image: action.image, callback: { [weak self] in
                self?.pause()
                action.callback()
            })
            let button = ActionButton(action: action, type: .icon)
            button.tintColor = .white.withAlphaComponent(0.7)
            button.withSize(.init(width: 36, height: 36))
            actionStack.addArrangedSubview(button)
        }
    }

    private func setup(url: URL) {
        let asset = AVURLAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        avPlayerVC.player?.replaceCurrentItem(with: playerItem)
        avPlayerVC.player?.seek(to: .zero)
        canPlaying = true
        playIfNeed()
    }

    private func pause() {
        self.hidingControlsWorkItem?.cancel()
        self.hidingControlsWorkItem = nil
        avPlayerVC.player?.pause()
        controlView.isHidden = false
        actionStack.isHidden = false
        controlView.setPlayingState(isPlaying: false)
        try? audioSession.setCategory(.soloAmbient)
    }

    private func resumePlaying() {
        self.hidingControlsWorkItem?.cancel()
        self.hidingControlsWorkItem = nil
        try? audioSession.setActive(true)
        try? audioSession.setCategory(.playback)
        avPlayerVC.player?.play()
        controlView.setPlayingState(isPlaying: true)
        let hidingControlsWorkItem = DispatchWorkItem { [weak self] in
            self?.controlView.isHidden = true
            self?.actionStack.isHidden = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: hidingControlsWorkItem)
        self.hidingControlsWorkItem = hidingControlsWorkItem
    }

    private func playIfNeed() {
        if canPlaying && needsToPlay {
            resumePlaying()
        }
    }

    private func changeLoading(isLoading: Bool) {
        if loadingImageView.isHidden == !isLoading { return }
        loadingImageView.isHidden = !isLoading
        if isLoading {
            loadingImageView.startRotating()
        } else {
            loadingImageView.stopRotation()
        }
    }

    // MARK: - Actions
    @objc private func playerItemDidReachEnd(notification: Notification) {
        pause()
        needsToPlay = false
        avPlayerVC.player?.seek(to: .zero)
    }

    @objc private func handleInterruption(notification: Notification) {
        guard let info = notification.userInfo,
              let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }
        if type == .began {
            pause()
        } else if type == .ended {
            guard let optionsValue = info[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume) {
                playIfNeed()
            }
        }
    }

    @objc private func handleTapOnVideoView() {
        controlView.isHidden.toggle()
        actionStack.isHidden = controlView.isHidden
    }

    private func stringDuration(duration: Double) -> String {
        let min = Int(duration / 60)
        let sec = Int(duration.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", min, sec)
    }
}

extension MediaGalleryVideoCell: VideoControlsDelegate {
    func playClicked() {
        if avPlayerVC.player?.isPlaying == true {
            pause()
            needsToPlay = false
        } else {
            needsToPlay = true
            resumePlaying()
        }
    }

    func progressChanged(progress: Float) {
        guard let duration = avPlayerVC.player?.currentItem?.duration else { return }
        let totalSeconds = CMTimeGetSeconds(duration)
        guard !(totalSeconds.isNaN || totalSeconds.isInfinite) else { return }
        let value = Double(progress) * totalSeconds
        let seekTime = CMTime(seconds: value, preferredTimescale: duration.timescale)
        avPlayerVC.player?.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .zero)
    }
}

extension MediaGalleryVideoCell: MediaGalleryCellProtocol {
    func prepareForRotation() {
        pause()
    }

    func resumeAfterRotation() {
        playIfNeed()
    }
}
