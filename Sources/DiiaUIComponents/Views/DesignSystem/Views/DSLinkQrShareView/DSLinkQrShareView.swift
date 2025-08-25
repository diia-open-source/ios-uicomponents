
import UIKit
import Lottie
import DiiaCommonTypes

/// design_system_code: linkQrShareOrg
public class DSLinkQrShareView: BaseCodeView {
    
    // MARK: - Subviews
    private let chipBlackTabsView = DSCenterChipBlackTabsOrgView()
    private let linkSharingView = DSLinkSharingOrgView()
    private let qrCodeOrgView = DSQrCodeOrgView()
    private let paginationMessageView = DSPaginationMessageMlcView()
    
    private let loadingContainerView = UIView()
    private lazy var loadingView: LottieAnimationView = {
        let lottieView = LottieAnimationView(animation: .named("loader"))
        lottieView.loopMode = .loop
        lottieView.backgroundBehavior = .pauseAndRestore
        return lottieView
    }()
    
    // MARK: - Properties
    private var viewModel: DSLinkQrShareViewModel?
    
    // MARK: - Init
    public override func setupSubviews() {
        backgroundColor = .white
        loadingContainerView.backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true
        
        let sharingContainerView = UIView()
        sharingContainerView.addSubviews([
            linkSharingView,
            qrCodeOrgView,
            paginationMessageView
        ])
        linkSharingView.fillSuperview()
        qrCodeOrgView.fillSuperview()
        paginationMessageView.fillSuperview()
        
        UIStackView.create(
            views: [chipBlackTabsView, sharingContainerView],
            spacing: Constants.stackSpacing,
            in: self,
            padding: Constants.contentPaddings
        )
        
        loadingContainerView.addSubview(loadingView)
        addSubview(loadingContainerView)
        loadingContainerView.fillSuperview()
        loadingView.withSize(Constants.loadingSize)
        loadingView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DSLinkQrShareViewModel) {
        self.viewModel?.model.removeObserver(observer: self)
        self.viewModel?.loadingState.removeObserver(observer: self)
        
        self.viewModel = viewModel
        
        viewModel.model.observe(observer: self) { [weak self] model in
            guard let self else { return }
            
            self.chipBlackTabsView.isHidden = model.centerChipBlackTabsOrg == nil
            if let chipBlackTabsViewModel = self.viewModel?.centerChipBlackTabsViewModel {
                self.chipBlackTabsView.configure(with: chipBlackTabsViewModel, eventHandler: viewModel.eventHandler)
            }
            
            self.linkSharingView.isHidden = model.linkSharingOrg == nil
            if let linkSharingViewModel = self.viewModel?.linkSharingViewModel {
                self.linkSharingView.configure(with: linkSharingViewModel)
            }
            
            self.qrCodeOrgView.isHidden = model.qrCodeOrg == nil
            if let qrCodeViewModel = self.viewModel?.qrCodeViewModel {
                self.qrCodeOrgView.configure(viewModel: qrCodeViewModel, eventHandler: viewModel.eventHandler)
            }
            
            self.paginationMessageView.isHidden = model.paginationMessageMlc == nil
            if let paginationMessage = self.viewModel?.paginationMessage {
                self.paginationMessageView.configure(with: paginationMessage)
            }
        }
        
        viewModel.loadingState.observe(observer: self) { [weak self] loadingState in
            guard let self else { return }
            
            switch loadingState {
            case .loading:
                self.loadingContainerView.isHidden = false
                self.loadingView.play()
            case .ready:
                self.loadingContainerView.isHidden = true
                self.loadingView.pause()
            }
        }
    }
}

// MARK: - Constants
private extension DSLinkQrShareView {
    enum Constants {
        static let loadingSize = CGSize(width: 80, height: 80)
        static let cornerRadius: CGFloat = 24
        static let contentPaddings = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        static let stackSpacing: CGFloat = 16
    }
}
