
import Foundation
import AVKit
import UIKit

final public class DSFullScreenVideoView: BaseCodeView {
    private let contentView = UIView()
    private let fadeView = UIView()
    private let audioSession = AVAudioSession.sharedInstance()
    private let playerController = AVPlayerViewController()
    private let playerButton = UIButton()
    private let mainButton = ActionLoadingStateButton()
    private let altButton = ActionLoadingStateButton()
    private let buttonsStackView = UIStackView().stack([], alignment: .center)
    private var videoControlsHandler: DSFullScreenVideoControlsView?
    private var observations: [NSKeyValueObservation] = []
    
    // MARK: LifeCycle
    public override func setupSubviews() {
        addSubViews()
        setupLayout()
        
        setupPlayerButton()
        setupActionButtons()
        setupVideoControlsHandler()
        addObservers()
        fadeView.backgroundColor = .black
        playerController.showsPlaybackControls = false
        playerController.view.isUserInteractionEnabled = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime,
                                                  object: playerController.player?.currentItem)
        try? audioSession.setCategory(.soloAmbient)
    }
    
    // MARK: Configuration
    public func configure(with model: DSFullScreenVideoOrg, actionHandler: ConstructorItemEvent? = nil) {
        guard let videoURL = URL(string: model.source) else { return }
        let asset = AVURLAsset(url: videoURL)
        let playerItem = AVPlayerItem(asset: asset)
        playerController.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerController.player = AVPlayer()
        playerController.player?.replaceCurrentItem(with: playerItem)
        addObservations(for: playerItem)
        
        buttonsStackView.isHidden = model.btnPrimaryDefaultAtm == nil && model.btnPlainAtm == nil
        mainButton.isHidden = model.btnPrimaryDefaultAtm == nil
        if let primaryButton = model.btnPrimaryDefaultAtm,
           let action = primaryButton.action {
            mainButton.setLoadingState(.enabled, withTitle: primaryButton.label)
            mainButton.onClick = { [weak self] in
                self?.pauseVideo()
//                actionHandler?(.action(.init("")))
            }
        }
        
        altButton.isHidden = model.btnPlainAtm == nil
        if let btnPlainAtm = model.btnPlainAtm,
           let action = btnPlainAtm.action {
            altButton.setStyle(style: .plain)
            altButton.setLoadingState(.enabled, withTitle: btnPlainAtm.label)
            altButton.onClick = { [weak self] in
                self?.pauseVideo()
//                actionHandler?(action)
            }
        }
    }
    
    // MARK: Setup
    private func addSubViews() {
        addSubview(contentView)
        contentView.addSubview(playerController.view)
        contentView.addSubview(fadeView)
        contentView.addSubview(playerButton)
        contentView.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubviews([mainButton, altButton])
    }
    
    private func setupLayout() {
        contentView.fillSuperview()
        playerController.view.fillSuperview()
        fadeView.fillSuperview()
        playerButton.withSize(Constants.buttonSize)
        playerButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        playerButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        buttonsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30).isActive = true
        buttonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        buttonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        mainButton.withHeight(Constants.buttonHeight)
        altButton.withHeight(Constants.buttonHeight)
        buttonsStackView.addArrangedSubviews([mainButton, altButton])
    }
    
    private func setupVideoControlsHandler() {
        videoControlsHandler = DSFullScreenVideoControlsView(playPauseButton: playerButton, fadeView: fadeView)
    }
    
    private func setupPlayerButton() {
        playerButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
    }
    
    private func setupActionButtons() {
        mainButton.titleLabel?.font = FontBook.bigText
        mainButton.contentEdgeInsets = Constants.buttonInsets
        altButton.titleLabel?.font = FontBook.bigText
    }
    
    private func addObservers() {
        let handleTapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(handleTapOnVideoView))
            contentView.addGestureRecognizer(handleTapGestureRecogniser)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: playerController.player?.currentItem)
        try? audioSession.setActive(true)
    }
    
    // MARK: Private methods
    private func setPlayerState(play: Bool) {
        guard let player = playerController.player else { return }
        if play {
            player.play()
        } else {
            player.pause()
        }
    }
    
    private func setReplayState() {
        videoControlsHandler?.setVisibility(visibility: .shown)
        videoControlsHandler?.setState(state: .replay)
    }
    
    private func isPlayerPlaying() -> Bool {
        guard let player = playerController.player else { return false }
        return player.isPlaying
    }
    
    private func pauseVideo() {
        if isPlayerPlaying() {
            setPlayerState(play: false)
            videoControlsHandler?.onPlayPauseButtonTapped()
        }
    }
    
    private func playPauseButtonTapped(btnState: PlayPauseButtonState) {
        switch btnState {
        case .play:
            setPlayerState(play: true)
        case .pause:
            setPlayerState(play: false)
        case .replay:
            playerController.player?.seek(to: .zero)
            setPlayerState(play: true)
        default:
            break
        }
    }
    
    private func addObservations(for playerItem: AVPlayerItem) {
        observations = [
            playerItem.observe(\.isPlaybackBufferEmpty, onChange: { [weak self] _ in
                self?.videoControlsHandler?.setState(state: .loading)
                self?.videoControlsHandler?.setVisibility(visibility: .shown)
            }),
            playerItem.observe(\.isPlaybackLikelyToKeepUp, onChange: { [weak self] _ in
                if self?.isPlayerPlaying() == true {
                    self?.videoControlsHandler?.setState(state: .pause)
                    self?.videoControlsHandler?.setVisibility(visibility: .hiding)
                } else {
                    self?.videoControlsHandler?.setState(state: .play)
                    self?.videoControlsHandler?.setVisibility(visibility: .shown)
                }
            }),
            audioSession.observe(\.outputVolume, options: [.new]) { [weak self] _, _ in
                if self?.isPlayerPlaying() == true {
                    try? self?.audioSession.setCategory(.playback)
                }
            }
        ]
    }
    
    // MARK: Actions
    @objc func handleTapOnVideoView() {
        guard let videoControlsHandler = videoControlsHandler else { return }
        switch videoControlsHandler.getVisibility() {
        case .hidden:
            videoControlsHandler.setVisibility(visibility: .shown)
            videoControlsHandler.setVisibility(visibility: .hiding)
        default:
            videoControlsHandler.setVisibility(visibility: .hidden)
        }
    }
        
    @objc func playerItemDidReachEnd(notification: Notification) {
        setPlayerState(play: false)
        setReplayState()
    }
    
    @objc private func playVideo() {
        guard let videoControlsHandler = videoControlsHandler else { return }
        playPauseButtonTapped(btnState: videoControlsHandler.getState())
        videoControlsHandler.onPlayPauseButtonTapped()
    }
}

private extension DSFullScreenVideoView {
    enum Constants {
        static let cornerRadius: CGFloat = 16
        static let alpha: CGFloat = 0.5
        static let delay: DispatchTime = .now() + 3
        static let buttonInsets = UIEdgeInsets.init(top: 0, left: 62, bottom: 0, right: 62)
        static let buttonSize = CGSize(width: 64, height: 64)
        static let buttonHeight: CGFloat = 48
        static let imageInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
}
