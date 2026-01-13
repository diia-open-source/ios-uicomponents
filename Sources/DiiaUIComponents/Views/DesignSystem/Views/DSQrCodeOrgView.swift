
import UIKit
import Foundation
import DiiaCommonTypes
import Lottie

final public class DSQrCodeOrgView: BaseCodeView {
    // MARK: - Properties
    private let contentStackView = UIStackView.create()
    
    private let textLabel = UILabel().withParameters(
        font: FontBook.mainFont.regular.size(12),
        numberOfLines: Constants.textNumberOfLines,
        textAlignment: .center,
        lineBreakMode: .byTruncatingTail
    )
    
    private let textLabelContainer = UIView().withHeight(Constants.textLabelContainerHeight)
    
    private let qrCodeView = DSQRCodeMlcView()
    
    private let expireTimerLabel = DSExpireLabel()
    private let expireTextLabel = UILabel().withParameters(
        font: FontBook.statusFont,
        textColor: UIColor.black.withAlphaComponent(Constants.expireLabelAlphaColor)
    )
    private lazy var expireLabelStackView = UIStackView.create(
        views: [expireTimerLabel, expireTextLabel],
        alignment: .center
    )
    
    private let iconedButton = IconedLoadingStateView()

    private let paginationMessageView = DSPaginationMessageMlcView()

    private lazy var loadingView: LottieAnimationView = {
        let lottieView = LottieAnimationView(animation: .named("loader"))
        lottieView.loopMode = .loop
        lottieView.backgroundBehavior = .pauseAndRestore
        return lottieView
    }()

    private let contentView = UIView()

    private var viewModel: DSQrCodeOrgViewModel?
    
    // MARK: - Lifecycle
    public override func setupSubviews() {
        withHeight(Constants.viewHeight)

        // main view layout
        addSubview(contentView)
        contentView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor
        )

        addSubview(iconedButton)
        iconedButton.withHeight(Constants.buttonHeight)
        iconedButton.anchor(
            top: contentView.bottomAnchor,
            bottom: bottomAnchor,
        )
        iconedButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        contentView.addSubview(contentStackView)
        contentStackView.fillSuperview()
        contentStackView.addArrangedSubviews([textLabelContainer, expireLabelStackView])

        // contentView contents layout
        textLabelContainer.addSubview(textLabel)
        textLabel.anchor(
            top: textLabelContainer.topAnchor,
            leading: textLabelContainer.leadingAnchor,
            trailing: textLabelContainer.trailingAnchor
        )
        textLabel.bottomAnchor.constraint(lessThanOrEqualTo: textLabelContainer.bottomAnchor).isActive = true

        contentView.addSubview(loadingView)
        loadingView.withSize(Constants.loadingIconSize)
        loadingView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

        contentView.addSubview(paginationMessageView)
        paginationMessageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        paginationMessageView.anchor(leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)

        paginationMessageView.setDescriptionAlignment(.center)
    }
    
    // MARK: - Public
    public func configure(viewModel: DSQrCodeOrgViewModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.viewModel?.state.removeObserver(observer: self)
        self.viewModel?.timerText.removeObserver(observer: self)
        self.viewModel?.isExpired.removeObserver(observer: self)
        self.viewModel = viewModel

        paginationMessageView.setEventHandler(eventHandler)

        setupState(with: viewModel, eventHandler: eventHandler)

        viewModel.state.observe(observer: self) { [weak self, weak viewModel] state in
            guard let viewModel else { return }
            self?.setupState(with: viewModel, eventHandler: eventHandler)
        }
    }

    // MARK: - Private
    private func setupState(with viewModel: DSQrCodeOrgViewModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        hideAllViews()

        switch viewModel.state.value {
        case .loading:
            loadingView.isHidden = false
            loadingView.play()
        case .code(let model):
            if let paginationMessageModel = model.paginationMessageMlc {
                showPaginationMessage(paginationMessageModel)
            } else {
                textLabelContainer.isHidden = model.text == nil
                textLabel.text = model.text

                expireLabelStackView.isHidden = model.expireLabel == nil && model.expireLabelWithoutTimer == nil

                expireTextLabel.isHidden = model.expireLabelWithoutTimer == nil
                expireTimerLabel.isHidden = model.expireLabel == nil

                if let expireLabelModel = model.expireLabel {
                    expireTimerLabel.configure(for: expireLabelModel)
                    viewModel.setupTimer(for: expireLabelModel.timer)

                    addExpirationObservers(for: viewModel, model: model)
                } else if let expireLabelWithoutTimer = model.expireLabelWithoutTimer {
                    expireTextLabel.text = expireLabelWithoutTimer
                }

                setupQrCodeView(model: model)
                contentStackView.isHidden = false
                contentStackView.addArrangedSubview(UIView())

                iconedButton.isHidden = model.btnPlainIconAtm == nil
                if let buttonModel = model.btnPlainIconAtm {
                    let image = UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: buttonModel.icon) ?? UIImage()
                    let viewModel = IconedLoadingStateViewModel(
                        name: buttonModel.label,
                        image: image,
                        clickHandler: {
                            if let action = buttonModel.action {
                                eventHandler(.action(action))
                            }
                        },
                        componentId: buttonModel.componentId
                    )

                    iconedButton.configure(viewModel: viewModel)
                }
            }
        case .error(let paginationMessageModel):
            showPaginationMessage(paginationMessageModel)
        }
    }

    private func hideAllViews() {
        loadingView.pause()
        loadingView.isHidden = true
        iconedButton.isHidden = true
        textLabelContainer.isHidden = true
        paginationMessageView.isHidden = true
        expireLabelStackView.isHidden = true
        contentStackView.isHidden = true
        qrCodeView.isHidden = true
    }

    private func showPaginationMessage(_ model: DSPaginationMessageMlcModel) {
        paginationMessageView.isHidden = false
        paginationMessageView.configure(with: model)
    }

    private func setupQrCodeView(model: DSQrCodeOrgModel) {
        qrCodeView.isHidden = model.qrCodeMlc == nil
        guard let qrCodeMlcModel = model.qrCodeMlc else { return }

        qrCodeView.configure(for: qrCodeMlcModel)
        qrCodeView.anchor(size: Constants.qrCodeSize)

        let topPadding = topImagePadding()
        let bottomPadding = bottomImagePadding()

        let imagePaddingBox = UIView()
        imagePaddingBox.addSubview(qrCodeView)

        qrCodeView.anchor(
            top: imagePaddingBox.topAnchor,
            bottom: imagePaddingBox.bottomAnchor,
            padding: .init(bottom: bottomPadding, top: topPadding))
        qrCodeView.centerXAnchor.constraint(equalTo: imagePaddingBox.centerXAnchor).isActive = true

        if textLabelContainer.isHidden {
            contentStackView.insertArrangedSubview(imagePaddingBox, at: 0)
        } else {
            contentStackView.insertArrangedSubview(imagePaddingBox, at: 1)
        }
    }

    private func topImagePadding() -> CGFloat {
        if textLabelContainer.isHidden {
            return expireLabelStackView.isHidden ? 48.0 : 32.0
        } else {
            return 16.0
        }
    }

    private func bottomImagePadding() -> CGFloat {
        return expireLabelStackView.isHidden ? 48.0 : 16.0
    }

    private func addExpirationObservers(for viewModel: DSQrCodeOrgViewModel, model: DSQrCodeOrgModel) {
        viewModel.timerText.observe(observer: self) { [weak self] timerText in
            guard let self, let timerText else { return }
            self.expireTimerLabel.updateTimer(with: timerText)
        }

        viewModel.isExpired.observe(observer: self) { [weak self] isExpired in
            guard isExpired, let stateAfterExpiration = model.stateAfterExpiration else { return }
            self?.hideAllViews()
            self?.showPaginationMessage(stateAfterExpiration.paginationMessageMlc)
        }
    }
}

// MARK: - DSQrCodeOrgView+Constants
extension DSQrCodeOrgView {
    enum Constants {
        static let viewHeight: CGFloat = 390
        static let textLabelContainerHeight: CGFloat = 48
        static let textNumberOfLines = 3
        static let buttonHeight: CGFloat = 56
        static let expireLabelAlphaColor: CGFloat = 0.5
        static let qrCodeSize = CGSize(width: 230, height: 230)
        static let loadingIconSize = CGSize(width: 80, height: 80)
    }
}
