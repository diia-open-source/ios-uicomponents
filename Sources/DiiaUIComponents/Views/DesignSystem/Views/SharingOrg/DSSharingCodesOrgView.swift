
import Foundation
import UIKit
import Lottie

public final class DSSharingCodesOrgView: BaseCodeView {
    
    private let expireLabel = DSExpireLabel()
    private let qrCodeView = DSQRCodeMlcView()
    private let stubMessage = StubMessageViewV2()
    private let borderedActionsView = BorderedActionsView()
    
    private var viewModel: DSSharingCodesOrgViewModel?
    
    private var observations: [NSKeyValueObservation] = []
    
    private lazy var loadingView: BoxView<LottieAnimationView> = {
        let animation = LottieAnimation.named("loader")
        let lottieView = LottieAnimationView(animation: animation)
        lottieView.loopMode = .loop
        lottieView.backgroundBehavior = .pauseAndRestore
        
        let box = BoxView(subview: lottieView)
        box.backgroundColor = UIColor.init(white: 1, alpha: 0.5)
        box.withConstraints(size: Constants.loadingSize,
                            centeredX: true,
                            centeredY: true)
        return box
    }()
    
    public override func setupSubviews() {
        super.setupSubviews()
        
        addSubview(expireLabel)
        addSubview(qrCodeView)
        addSubview(borderedActionsView)
        addSubview(stubMessage)
        
        expireLabel.anchor(top: topAnchor,
                           padding: .init(top: Constants.largeOffset, left: 0, bottom: 0, right: 0))
        expireLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        qrCodeView.anchor(top: expireLabel.bottomAnchor,
                          leading: leadingAnchor,
                          trailing: trailingAnchor,
                          padding: .init(top: Constants.offset,
                                         left: Constants.imageQROffset,
                                         bottom: 0,
                                         right: Constants.imageQROffset))
        qrCodeView.heightAnchor.constraint(equalTo: qrCodeView.widthAnchor).isActive = true
        borderedActionsView.anchor(top: qrCodeView.bottomAnchor,
                                   leading: leadingAnchor,
                                   bottom: bottomAnchor,
                                   trailing: trailingAnchor,
                                   padding: .init(top: Constants.bottomOffset,
                                                  left: Constants.largeOffset,
                                                  bottom: 0,
                                                  right: Constants.largeOffset))
        stubMessage.anchor(leading: leadingAnchor,
                           bottom: borderedActionsView.topAnchor,
                           trailing: trailingAnchor,
                           padding: .init(top: Constants.largeOffset, left: 0, bottom: Constants.bottomOffset, right: 0))
    }
    
    public func configure(for model: DSSharingCodesOrgViewModel) {
        viewModel = model
        
        accessibilityIdentifier = model.sharingCodes.componentId
        qrCodeView.configure(for: model.sharingCodes.qrCodeMlc)
        stubMessage.configure(with: model.stubViewModel)
        if let btnTitle = model.stubViewModel.btnTitle {
            stubMessage.configure(btnTitle: btnTitle)
        }
        borderedActionsView.configureView(with: model.itemsVMs ?? [])
        
        if let expireLabelMlc = model.sharingCodes.expireLabel {
            expireLabel.configure(for: expireLabelMlc)
            model.setupTimer(for: expireLabelMlc.timer)
        }
        
        observations = [
            model.observe(\.isLoading, onChange: { [weak self] loading in
                self?.changeLoading(loading)
            }),
            model.observe(\.timerText, onChange: { [weak self] timerText in
                self?.changeExpireTimerLabel(for: timerText)
            }),
            model.observe(\.isExpired, onChange: { [weak self] isExpired in
                self?.showStubMsg(isExpired: isExpired)
            })
        ]
        
        viewModel?.isExpired = viewModel?.sharingCodes.expireLabel == nil
    }
    
    private func changeExpireTimerLabel(for text: String?) {
        guard let text = text else { return }
        self.expireLabel.updateTimer(with: text)
    }
    
    private func showStubMsg(isExpired: Bool) {
        expireLabel.isHidden = isExpired
        qrCodeView.layer.opacity = isExpired ? 0.01 : 1.0
        borderedActionsView.isUserInteractionEnabled = !isExpired
        borderedActionsView.alpha = isExpired ? 0.5 : 1.0
        
        guard let stubMsg = viewModel?.stubViewModel else { return }
        stubMessage.configure(with: stubMsg)
        stubMessage.isHidden = !isExpired
    }
    
    private func changeLoading(_ loading: Bool) {
        if loading {
            loadingView.subview.play()
        } else {
            loadingView.subview.pause()
        }
    }
}

extension DSSharingCodesOrgView {
    enum Constants {
        static let loadingSize = CGSize(width: 80,
                                        height: 80)
        static let offset: CGFloat = 16
        static let largeOffset: CGFloat = 24
        static let imageQROffset: CGFloat = 72
        static let bottomOffset: CGFloat = 40
    }
}
