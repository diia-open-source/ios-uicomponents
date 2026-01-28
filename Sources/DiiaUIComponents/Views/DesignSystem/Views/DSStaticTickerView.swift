
import UIKit
import DiiaCommonTypes

public final class DSStaticTickerView: BaseCodeView {
    // MARK: - Properties
    private let backgroundView = UIImageView()
    private let expireTimerLabel = DSExpireLabel(configuration: .init(
        font: FontBook.usualFont,
        textAlpha: 1,
        timerLabelWidth: Constants.timerLabelWidth))
    private let label = UILabel().withParameters(font: FontBook.usualFont, numberOfLines: 1)
    private lazy var mainHStackView = UIStackView.create(.horizontal, views: [label])

    private var viewModel: DSStaticTickerViewModel?
    private var eventHandler: ((ConstructorItemEvent) -> Void)?

    // MARK: - Lifecycle
    public override func setupSubviews() {
        addSubview(backgroundView)
        backgroundView.fillSuperview()

        withHeight(Constants.height)

        backgroundView.addSubview(mainHStackView)
        mainHStackView.anchor(
            leading: backgroundView.leadingAnchor,
            trailing: backgroundView.trailingAnchor,
            padding: UIEdgeInsets(horizontal: Constants.horizontalPadding))
        mainHStackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true

        label.isHidden = true
        expireTimerLabel.isHidden = true

        addSubview(expireTimerLabel)
        expireTimerLabel.translatesAutoresizingMaskIntoConstraints = false
        expireTimerLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        expireTimerLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tap)
    }

    // MARK: - Public Methods
    public func configure(with viewModel: DSStaticTickerViewModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.viewModel = viewModel
        self.eventHandler = eventHandler

        viewModel.type.removeObserver(observer: self)
        viewModel.label.removeObserver(observer: self)
        viewModel.timerText.removeObserver(observer: self)
        accessibilityIdentifier = viewModel.componentId

        viewModel.type.observe(observer: self) { [weak self] type in
            self?.backgroundView.image = viewModel.type.value.backgroundImage
        }

        viewModel.label.observe(observer: self) { [weak self] text in
            guard self?.label.text != text else { return }
            self?.label.text = text
        }

        label.textColor = viewModel.type.value.textColor

        label.isHidden = viewModel.expireLabel != nil
        expireTimerLabel.isHidden = viewModel.expireLabel == nil

        if let expireLabelModel = viewModel.expireLabel {
            expireTimerLabel.configure(for: expireLabelModel)
            viewModel.setupTimer(for: time(to: expireLabelModel.timer))

            viewModel.timerText.observe(observer: self) { [weak self] timerText in
                self?.expireTimerLabel.updateTimer(with: timerText ?? "")
            }
        } else {
            label.text = viewModel.label.value
        }
    }

    // MARK: - Private
    private func time(to timestamp: Int) -> Int {
        return timestamp - Int(Date().timeIntervalSince1970)
    }

    @objc private func onTap() {
        guard let action = viewModel?.action else { return }
        eventHandler?(.action(action))
    }
}

extension DSStaticTickerView {
    private enum Constants {
        static let horizontalPadding: CGFloat = 8
        static let height: CGFloat = 32.0
        static let timerLabelWidth: CGFloat = 40.0
    }
}
