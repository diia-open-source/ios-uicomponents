
import UIKit
import Foundation
import DiiaCommonTypes

final public class DSQrCodeOrgView: BaseCodeView {
    // MARK: - Properties
    private let titleLabel = UILabel().withParameters(font: FontBook.mainFont.regular.size(12), numberOfLines: 3, textAlignment: .center)
    private let qrCodeView = DSQRCodeMlcView()
    private let expireLabel = DSExpireLabel()
    private let expiredMessageView = DSPaginationMessageMlcView()

    private var viewModel: DSQrCodeOrgViewModel?

    private lazy var mainStackView = UIStackView
        .create(
            views: [titleLabel, expireLabel],
            alignment: .center
        )

    // MARK: - Lifecycle
    public override func setupSubviews() {
        addSubview(mainStackView)
        mainStackView.fillSuperview()

        expiredMessageView.isHidden = true
        addSubview(expiredMessageView)
        expiredMessageView.anchor(leading: leadingAnchor, trailing: trailingAnchor)
        expiredMessageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        titleLabel.anchor(size: .init(width: .zero, height: Constants.textHeight))
    }

    // MARK: - Public
    public func configure(viewModel: DSQrCodeOrgViewModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        titleLabel.isHidden = viewModel.text == nil
        titleLabel.text = viewModel.text

        expireLabel.isHidden = viewModel.expireLabel == nil
        if let expireLabelModel = viewModel.expireLabel {
            expireLabel.configure(for: expireLabelModel)
            viewModel.setupTimer(for: expireLabelModel.timer)

            addObservers(for: viewModel)
        }

        if let expiredMessageModel = viewModel.stateAfterExpiration {
            expiredMessageView.configure(with: expiredMessageModel.paginationMessageMlc)
            expiredMessageView.setEventHandler(eventHandler)
        }

        setupQrCodeView(viewModel: viewModel)
        addBottomSpacerIfNeeded(viewModel: viewModel)
        
        self.viewModel = viewModel
    }

    // MARK: - Private
    private func addBottomSpacerIfNeeded(viewModel: DSQrCodeOrgViewModel) {
        guard expireLabel.isHidden else { return }
        mainStackView.addArrangedSubview(UIView())
        mainStackView.setCustomSpacing(32.0, after: expireLabel)
    }

    private func setupQrCodeView(viewModel: DSQrCodeOrgViewModel) {
        qrCodeView.configure(for: viewModel.qrCodeMlc)

        let topPadding = topImagePadding(viewModel: viewModel)
        let bottomPadding = bottomImagePadding(viewModel: viewModel)
        let horizontalPadding: CGFloat = Constants.qrHorizontalPadding

        let insets = UIEdgeInsets(
            top: topPadding,
            left: horizontalPadding,
            bottom: bottomPadding,
            right: horizontalPadding
        )

        let imagePaddingBox = BoxView(subview: qrCodeView).withConstraints(insets: insets)
        if titleLabel.isHidden {
            mainStackView.insertArrangedSubview(imagePaddingBox, at: 0)
        } else {
            mainStackView.insertArrangedSubview(imagePaddingBox, at: 1)
        }
    }

    private func topImagePadding(viewModel: DSQrCodeOrgViewModel) -> CGFloat {
        if viewModel.text == nil {
            if viewModel.expireLabel == nil {
                return 48.0
            } else {
                return 32.0
            }
        } else {
            return 16.0
        }
    }

    private func bottomImagePadding(viewModel: DSQrCodeOrgViewModel) -> CGFloat {
        if viewModel.expireLabel == nil {
            return 48.0
        } else {
            return 16.0
        }
    }

    private func addObservers(for viewModel: DSQrCodeOrgViewModel) {
        self.viewModel?.timerText.removeObserver(observer: self)
        viewModel.timerText.observe(observer: self) { [weak self] timerText in
            guard let self, let timerText else { return }
            self.expireLabel.updateTimer(with: timerText)
        }

        self.viewModel?.isExpired.removeObserver(observer: self)
        viewModel.isExpired.observe(observer: self) { [weak self] isExpired in
            UIView.animate(withDuration: Constants.animationDuration, animations: {
                self?.mainStackView.alpha = isExpired ? 0 : 1
                self?.expiredMessageView.alpha = isExpired ? 1 : 0
            }, completion: { [weak self] _ in
                self?.mainStackView.isHidden = isExpired
                self?.expiredMessageView.isHidden = !isExpired
            })
        }
    }
}

// MARK: - DSQrCodeOrgView+Constants
extension DSQrCodeOrgView {
    enum Constants {
        static let textHeight: CGFloat = 48.0
        static let qrHorizontalPadding: CGFloat = 32.0
        static let animationDuration: TimeInterval = 0.2
    }
}
