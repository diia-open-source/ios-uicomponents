
import UIKit
import Lottie
import DiiaCommonTypes

/// design_system_code: verificationCodesOrg
public final class DSVerificationCodesView: BaseCodeView {
    private var contentStackView = UIStackView()
    private let stubMessageView = StubMessageViewV2()
    private let expireLabel = DSExpireLabel()
    private let qrCodeView = DSQRCodeMlcView()
    private let barCodeView = DSBarCodeMlcView()
    private let buttonGroupView = DSButtonToggleGroupView()
    private let staticSharingView = DSStaticVerificationView()
    
    private lazy var loadingView: BoxView<LottieAnimationView> = {
        let animation = LottieAnimation.named("loader")
        let lottieView = LottieAnimationView(animation: animation)
        lottieView.loopMode = .loop
        lottieView.backgroundBehavior = .pauseAndRestore
        
        let box = BoxView(subview: lottieView)
        box.backgroundColor = Constants.loadingBackgroundColor
        box.withConstraints(size: Constants.loadingSize,
                            centeredX: true,
                            centeredY: true)
        return box
    }()
    
    private var qrCodeHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Properties
    private var viewModel: DSVerificationCodesViewModel?
    
    // MARK: - Init
    public override func setupSubviews() {
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true
        
        let codesContainerView = UIStackView.create(views: [qrCodeView, barCodeView])
        qrCodeHeightConstraint = qrCodeView.heightAnchor.constraint(equalTo: qrCodeView.widthAnchor)
        
        let sharingStackView = UIStackView.create(
            views: [expireLabel, codesContainerView],
            spacing: Constants.sharingStackSpacing,
            alignment: .center)
        
        let sharingViewContainer = UIView()
        sharingViewContainer.addSubview(sharingStackView)
        sharingStackView.anchor(leading: sharingViewContainer.leadingAnchor, trailing: sharingViewContainer.trailingAnchor, padding: Constants.sharingStackPadding)
        sharingStackView.centerYAnchor.constraint(equalTo: sharingViewContainer.centerYAnchor).isActive = true
        
        contentStackView = UIStackView.create(
            views: [sharingViewContainer, buttonGroupView],
            in: self,
            padding: Constants.contentPadding)
        
        addSubviews([staticSharingView, stubMessageView, loadingView])
        stubMessageView.translatesAutoresizingMaskIntoConstraints = false
        stubMessageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stubMessageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        staticSharingView.translatesAutoresizingMaskIntoConstraints = false
        staticSharingView.fillSuperview()
        staticSharingView.isHidden = true
        loadingView.fillSuperview()
        
        showLoading(true)
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DSVerificationCodesViewModel) {
        accessibilityIdentifier = viewModel.componentId
    
        self.viewModel?.sharingCode.removeObserver(observer: self)
        viewModel.sharingCode.observe(observer: self) { [weak self] sharingCode in
            guard let self, let sharingCode else { return }
            self.updateSharing(code: sharingCode)
        }
        
        self.viewModel?.model.removeObserver(observer: self)
        viewModel.model.observe(observer: self) { [weak self] model in
            guard let self, let model else { return }
            self.configure(model: model)
        }
        
        self.viewModel?.timerText.removeObserver(observer: self)
        viewModel.timerText.observe(observer: self) { [weak self] timerText in
            self?.changeExpireTimerLabel(for: timerText)
        }
        
        self.viewModel?.isExpired.removeObserver(observer: self)
        viewModel.isExpired.observe(observer: self) { [weak self] isExpired in
            self?.showStubMessage(isExpired)
        }
        
        self.viewModel = viewModel
    }
    
    // MARK: - Private Methods
    private func configure(model: DSVerificationCodesData) {
        guard let viewModel = viewModel else { return }
        contentStackView.isHidden = viewModel.isStatic
        staticSharingView.isHidden = !viewModel.isStatic
        if viewModel.isStatic, let staticViewModel = viewModel.staticViewModel {
            showLoading(false)
            staticSharingView.configure(with: staticViewModel)
            return
        }
        
        expireLabel.isHidden = model.expireLabel == nil
        if let expireLabelModel = model.expireLabel {
            expireLabel.configure(for: expireLabelModel)
            viewModel.setupTimer(for: expireLabelModel.timer)
        }
        
        qrCodeView.isHidden = model.qrCodeMlc == nil
        if let qrCodeModel = model.qrCodeMlc {
            qrCodeView.configure(for: qrCodeModel)
        }
        
        barCodeView.isHidden = model.barCodeMlc == nil
        if let barCodeModel = model.barCodeMlc {
            barCodeView.configure(for: barCodeModel)
        }
        
        if let stubMessageVM = viewModel.stubMessage {
            stubMessageVM.repeatAction = { [weak self] in
                guard let self = self else { return }
                self.showLoading(true)
                self.viewModel?.repeatAction?()
            }
            stubMessageView.configure(with: stubMessageVM)
            stubMessageView.configure(btnTitle: viewModel.model.value?.stubMessageMlc?.btnStrokeAdditionalAtm?.label ?? .empty)
        }
        
        if let buttonGroup = viewModel.buttonsToggleGroup {
            buttonGroupView.configure(with: buttonGroup)
        }
        
        let isError = model.qrCodeMlc == nil && model.barCodeMlc == nil && viewModel.stubMessage != nil
        if isError {
            showLoading(false)
            showStubMessage(true)
        } else {
            showLoading(model.qrCodeMlc == nil && model.barCodeMlc == nil)
            showStubMessage(false)
        }
    }
    
    private func changeExpireTimerLabel(for text: String?) {
        guard let text = text else { return }
        expireLabel.updateTimer(with: text)
    }
    
    private func showStubMessage(_ isShowing: Bool) {
        stubMessageView.isHidden = !isShowing
        expireLabel.isHidden = isShowing
        qrCodeView.layer.opacity = isShowing ? Constants.inactiveOpacity : 1.0
        barCodeView.layer.opacity = isShowing ? Constants.inactiveOpacity : 1.0
        buttonGroupView.isUserInteractionEnabled = !isShowing
        buttonGroupView.alpha = isShowing ? Constants.inactiveColorAlpha : 1.0
    }
    
    private func updateSharing(code: String) {
        switch code {
        case Constants.qrActionCode:
            qrCodeView.isHidden = false
            barCodeView.isHidden = true
            qrCodeHeightConstraint?.isActive = true
        case Constants.barcodeActionCode:
            qrCodeView.isHidden = true
            barCodeView.isHidden = false
            qrCodeHeightConstraint?.isActive = false
        default:
            return
        }
    }
    
    private func showLoading(_ isShowing: Bool) {
        loadingView.isHidden = !isShowing
        isShowing ? loadingView.subview.play() : loadingView.subview.pause()
    }
}

// MARK: - Constants
extension DSVerificationCodesView {
    private enum Constants {
        static let loadingSize = CGSize(width: 80, height: 80)
        static let loadingBackgroundColor = UIColor(white: 1, alpha: 0.5)
        static let cornerRadius: CGFloat = 24
        static let contentPadding = UIEdgeInsets(top: 24, left: .zero, bottom: .zero, right: .zero)
        static let sharingStackPadding = UIEdgeInsets(top: .zero, left: 40, bottom: .zero, right: 40)
        static let sharingStackSpacing: CGFloat = 12
        static let inactiveOpacity: Float = 0.01
        static let inactiveColorAlpha: CGFloat = 0.01
        static let qrActionCode = "qr"
        static let barcodeActionCode = "barcode"
    }
}
