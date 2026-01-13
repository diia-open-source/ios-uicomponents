
import UIKit

public enum PlayPauseButtonState: String {
    case loading
    case pause
    case play
    case replay
}

public enum VidoControlsHandlerVisibility: String {
    case shown
    case hiding
    case hidden
}

final class DSFullScreenVideoControlsView: UIView {
    private let playPauseImageView = UIImageView()
    private let playPauseBackgroundImageView = UIImageView()
    private var btnState: PlayPauseButtonState = .loading
    private var controlsVisibility: VidoControlsHandlerVisibility = .shown
    private var playPauseButton: UIButton?
    private var fadeView: UIView?
    
    /// Counter uses for checking number of times when controls were hidden but allows to hide just on the last time after 3 seconds after showing
    private var counter = 0
    
    // MARK: - Initialize
    init(playPauseButton: UIButton,
         fadeView: UIView) {
        super.init(frame: CGRect(origin: .zero, size: Constants.buttonSize))
        self.playPauseButton = playPauseButton
        self.fadeView = fadeView
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    // MARK: - Configuration
    func configure() {
        setupUI()
        setVisibility(visibility: controlsVisibility)
        setState(state: btnState)
        playPauseButton?.contentHorizontalAlignment = .center
    }
    
    // MARK: - Public methods
    func setState(state: PlayPauseButtonState) {
        btnState = state
        updateImage()
    }
    
    func getState() -> PlayPauseButtonState {
        return btnState
    }
    
    func setVisibility(visibility: VidoControlsHandlerVisibility) {
        switch visibility {
        case .shown:
            playPauseButton?.alpha = 1
            playPauseButton?.isHidden = false
            fadeView?.alpha = Constants.defaultAlphaForFade
            fadeView?.isHidden = false
        case .hiding:
            counter += 1
            onMainQueueAfter(time: Constants.stateTime) { [weak self] in
                self?.counter -= 1
                guard let self = self, self.counter == 0, self.btnState == .pause else { return }
                UIView.animate(
                    withDuration: Constants.hidingDuration,
                    animations: {
                        [self.playPauseButton, self.fadeView].forEach { $0?.alpha = 0 }
                    },
                    completion: { [weak self] _ in
                        guard let self = self else { return }
                        [self.playPauseButton, self.fadeView].forEach { $0?.isHidden = true }
                        self.controlsVisibility = .hidden
                    })
            }
        case .hidden:
            UIView.animate(
                withDuration: Constants.hiddenDuration,
                animations: {
                    [self.playPauseButton, self.fadeView].forEach { $0?.alpha = 0 }
                },
                completion: { [weak self] _ in
                    guard let self = self else { return }
                    [self.playPauseButton, self.fadeView].forEach { $0?.isHidden = true }
                })
        }
        controlsVisibility = visibility
    }
    
    func getVisibility() -> VidoControlsHandlerVisibility {
        return controlsVisibility
    }
    
    // MARK: - Private methods
    private func setupUI() {
        guard let playPauseButton = playPauseButton else { return }
        playPauseButton.contentHorizontalAlignment = .center
        playPauseButton.contentVerticalAlignment = .center
        playPauseButton.setTitle("", for: .normal)
        
        [playPauseBackgroundImageView, playPauseImageView].forEach { imageView in
            playPauseButton.addSubview(imageView)
            imageView.centerXAnchor.constraint(equalTo: playPauseButton.centerXAnchor).isActive = true
            imageView.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor).isActive = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
        }
        playPauseBackgroundImageView.image = R.image.play.image
        playPauseImageView.image = UIImage(named: btnState.rawValue)?.withRenderingMode(.alwaysOriginal)
    }
    
    private func updateImage() {
        playPauseImageView.stopRotation()
        let image = UIImage(named: btnState.rawValue)?.withRenderingMode(.alwaysOriginal)
        playPauseImageView.image = image
        
        if btnState == .loading {
            playPauseImageView.startRotating()
        }
    }
    
    // MARK: - Actions
    func onPlayPauseButtonTapped() {
        setVisibility(visibility: .shown)
        switch btnState {
        case .loading:
            setState(state: .loading)
        case .play, .replay:
            setState(state: .pause)
            setVisibility(visibility: .hiding)
        case .pause:
            setState(state: .play)
        }
    }
}

// MARK: - Constants
private extension DSFullScreenVideoControlsView {
    enum Constants {
        static let stateTime: TimeInterval = 1.0
        static let hidingDuration: TimeInterval = 0.6
        static let hiddenDuration: TimeInterval = 0.3
        static let defaultAlphaForFade: CGFloat = 0.4
        
        static let buttonSize = CGSize(width: 64, height: 64)
    }
}
