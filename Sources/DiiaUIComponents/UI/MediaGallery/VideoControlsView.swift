import UIKit

protocol VideoControlsDelegate: NSObjectProtocol {
    func playClicked()

    func progressChanged(progress: Float)
}

class VideoControlsView: UIView {
    private let playButton = UIButton()
    private let progressView = UISlider()
    private let durationLabel = UILabel()
    private let timeLabel = UILabel()

    weak var delegate: VideoControlsDelegate?

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
        applyAppearance()
        addTargets()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        addSubview(playButton)
        addSubview(progressView)
        addSubview(durationLabel)
        addSubview(timeLabel)
    }

    private func makeConstraints() {
        playButton.withSize(.init(width: 48, height: 48))
        playButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        progressView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 24, bottom: 48, right: 24), size: .init(width: 0, height: 16))
        durationLabel.anchor(top: nil, leading: nil, bottom: progressView.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 4, right: 24))
        timeLabel.anchor(top: nil, leading: leadingAnchor, bottom: progressView.topAnchor, trailing: nil, padding: .init(top: 0, left: 24, bottom: 4, right: 0))

    }

    private func applyAppearance() {
        [durationLabel, timeLabel].forEach {
            $0.font = FontBook.usualFont
            $0.textColor = .white
        }

        progressView.maximumTrackTintColor = .white.withAlphaComponent(0.25)
        progressView.tintColor = .white
        progressView.setThumbImage(R.image.playbackSliderThumb.image, for: .normal)
    }

    private func addTargets() {
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        progressView.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
    }

    // MARK: - Actions
    @objc private func handleSliderChange() {
        delegate?.progressChanged(progress: progressView.value)
    }

    @objc private func playTapped() {
        delegate?.playClicked()
    }

    // MARK: - Public
    func setPlayingState(isPlaying: Bool) {
        playButton.setImage(isPlaying ? R.image.pause.image : R.image.play.image, for: .normal)
        if !isPlaying {
            progressView.layer.removeAllAnimations()
        }
    }

    func setDuration(duration: String) {
        durationLabel.text = duration
    }

    func setCurrentTime(currentTime: String) {
        timeLabel.text = currentTime
    }

    func updateProgress(progress: Float) {
        progressView.value = progress
    }
}
