
import UIKit
import AVFoundation

/// design_system_code:  btnSlideMlc
final public class DSBtnSlideMlcView: BaseCodeView {
    private let titleLabel = UILabel().withParameters(font: FontBook.usualFont, numberOfLines: 1, textAlignment: .center)
    private let imageView = UIImageView().withSize(Constants.imageSize)
    private let knobView = UIView()
    private let imageContainer = UIView()

    private var knobWidthConstraints: AnchoredConstraints?
    private var eventHandler: ((ConstructorItemEvent) -> Void)?
    private var model: DSBtnSlideMlcModel?

    // MARK: - Lifecycle
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        setTitleLabelColorAnimated(.black.withAlphaComponent(Constants.startTouchedTitleOpacity), duration: Constants.defaultAnimationDuration)
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        setTitleLabelColorAnimated(.black, duration: Constants.reverseAnimationDuration)
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        setTitleLabelColorAnimated(.black, duration: Constants.defaultAnimationDuration)
    }

    override public func setupSubviews() {
        withHeight(Constants.height)

        backgroundColor = .white
        layer.cornerRadius = Constants.height * 0.5
        layer.masksToBounds = true

        addSubview(titleLabel)
        titleLabel
            .anchor(
                leading: leadingAnchor,
                trailing: trailingAnchor,
                padding: UIEdgeInsets(
                    top: .zero,
                    left: Constants.height,
                    bottom: .zero,
                    right: Constants.height
                )
            )
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        let knobSize = CGSize(width: Constants.knobSize, height: Constants.knobSize)

        addSubview(knobView)
        knobView.backgroundColor = .black
        knobView.layer.cornerRadius = Constants.knobSize * 0.5
        knobView.clipsToBounds = true
        knobView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        knobWidthConstraints = knobView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            padding: UIEdgeInsets(
                top: Constants.knobInset,
                left: Constants.knobInset,
                bottom: Constants.knobInset,
                right: .zero
            ),
            size: knobSize
        )

        knobView.addSubview(imageContainer)
        imageContainer
            .anchor(
                trailing: knobView.trailingAnchor,
                size: knobSize
            )
        imageContainer.centerYAnchor.constraint(equalTo: knobView.centerYAnchor).isActive = true

        imageContainer.addSubview(imageView)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor).isActive = true

        addGesture()
    }

    // MARK: - Public Methods
    public func configure(with model: DSBtnSlideMlcModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.model = model
        self.eventHandler = eventHandler
        
        self.titleLabel.text = model.label

        self.imageContainer.isHidden = model.icon == nil
        if let iconModel = model.icon {
            self.imageView.image = UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: iconModel.code)
        }

        if model.state == .disabled {
            self.isUserInteractionEnabled = false
            self.titleLabel.textColor = .black.withAlphaComponent(Constants.disabledAlpha)
            self.knobView.backgroundColor = .black.withAlphaComponent(Constants.disabledAlpha)
        }
    }

    // MARK: - Private Methods
    private func addGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        panGesture.delaysTouchesBegan = false
        panGesture.cancelsTouchesInView = false
        knobView.addGestureRecognizer(panGesture)
    }

    private func setTitleLabelColorAnimated(_ color: UIColor, duration: TimeInterval) {
        let changeColor = CATransition()
        changeColor.duration = duration

        CATransaction.begin()

        CATransaction.setCompletionBlock { [weak self] in
            self?.titleLabel.layer.add(changeColor, forKey: nil)
            self?.titleLabel.textColor = color
        }

        CATransaction.commit()
    }

    // MARK: - Actions
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let maxWidth = bounds.width - Constants.knobSize - Constants.knobInset * 2

        var newWidth = Constants.knobInset + translation.x
        newWidth = max(.zero, min(newWidth, maxWidth))

        switch gesture.state {
        case .changed:
            let progress = 1 - min(1, max(0, newWidth / maxWidth))
            let opacity = Constants.startTouchedTitleOpacity * progress

            self.knobWidthConstraints?.width?.constant = Constants.knobSize + newWidth
            self.titleLabel.textColor = .black.withAlphaComponent(opacity)
        case .ended, .cancelled:
            if newWidth > maxWidth * Constants.finishPoint {
                UIView.animate(withDuration: Constants.defaultAnimationDuration) {
                    self.knobWidthConstraints?.width?.constant = self.bounds.width - Constants.knobInset * 2
                    self.layoutIfNeeded()
                } completion: { isFinished in
                    guard isFinished else { return }
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                    guard let action = self.model?.action else { return }
                    self.eventHandler?(.action(action))
                }
            } else {
                UIView.animate(withDuration: Constants.reverseAnimationDuration,
                               delay: .zero,
                               options: .curveEaseOut) {
                    self.knobWidthConstraints?.width?.constant = Constants.knobSize
                    self.layoutIfNeeded()
                }
            }
        default:
            break
        }
    }
}

// MARK: - DSBtnSlideMlcView+Constants
private extension DSBtnSlideMlcView {
    enum Constants {
        static let height: CGFloat = 64.0
        static let knobSize: CGFloat = height * 0.75
        static let knobInset: CGFloat = (height - knobSize) * 0.5
        static let startTouchedTitleOpacity: CGFloat = 0.5
        static let imageSize = CGSize(width: 24.0, height: 24.0)
        static let finishPoint: CGFloat = 0.9
        static let reverseAnimationDuration: TimeInterval = 0.2
        static let defaultAnimationDuration: TimeInterval = 0.1
        static let disabledAlpha: CGFloat = 0.3
    }
}
