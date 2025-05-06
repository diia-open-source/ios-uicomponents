
import Foundation
import UIKit
import DiiaCommonTypes

public struct DSQRSharingViewModel {
    let qrSharingOrg: DSQRSharingOrg
    let stubViewModel: StubMessageViewModel?
    let plainButtonViewModels: [IconedLoadingStateViewModel]?
    
    public init(qrSharingOrg: DSQRSharingOrg,
                stubViewModel: StubMessageViewModel? = nil,
                plainButtonViewModels: [IconedLoadingStateViewModel]? = nil) {
        self.qrSharingOrg = qrSharingOrg
        self.stubViewModel = stubViewModel
        self.plainButtonViewModels = plainButtonViewModels
    }
}

final public class DSQRSharingView: BaseCodeView {
    private let expireLabel = UILabel()
    private let shareImage = UIImageView()
    private let borderedActionsView = BorderedActionsView()
    private let stubMessage = StubMessageViewV2()
    
    public override func setupSubviews() {
        expireLabel.font = FontBook.statusFont
        expireLabel.textColor = UIColor.black.withAlphaComponent(0.5)
        shareImage.contentMode = .scaleAspectFit
        addSubview(expireLabel)
        addSubview(shareImage)
        addSubview(borderedActionsView)
        addSubview(stubMessage)
        expireLabel.anchor(top: topAnchor, padding: .init(top: Constants.largeOffset, left: 0, bottom: 0, right: 0))
        expireLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        shareImage.anchor(top: expireLabel.bottomAnchor,
                          leading: leadingAnchor,
                          trailing: trailingAnchor,
                          padding: .init(top: Constants.offset,
                                         left: Constants.imageQROffset,
                                         bottom: 0,
                                         right: Constants.imageQROffset))
        shareImage.heightAnchor.constraint(equalTo: shareImage.widthAnchor).isActive = true
        borderedActionsView.anchor(top: shareImage.bottomAnchor,
                                   leading: leadingAnchor,
                                   bottom: bottomAnchor,
                                   trailing: trailingAnchor,
                                   padding: .init(top: Constants.bottomOffset,
                                                  left: Constants.largeOffset,
                                                  bottom: 0,
                                                  right: Constants.largeOffset))
        stubMessage.anchor(top: topAnchor,
                           leading: leadingAnchor,
                           bottom: borderedActionsView.topAnchor,
                           trailing: trailingAnchor,
                           padding: .init(top: Constants.largeOffset, left: 0, bottom: Constants.bottomOffset, right: 0))
    }
    
    public func configure(viewModel: DSQRSharingViewModel) {
        expireLabel.text = viewModel.qrSharingOrg.expireLabel?.text
        shareImage.image = .qrCode(from: viewModel.qrSharingOrg.qrLink)
        if let plainButtonViewModels = viewModel.plainButtonViewModels {
            borderedActionsView.configureView(with: plainButtonViewModels)
        }
        let isStubMessage = viewModel.stubViewModel != nil
        stubMessage.isHidden = !isStubMessage
        [expireLabel, shareImage].forEach({$0.isHidden = isStubMessage})
        if let stubViewModel = viewModel.stubViewModel {
            stubMessage.configure(with: stubViewModel)
        }
    }
}

extension DSQRSharingView {
    enum Constants {
        static let offset: CGFloat = 16
        static let largeOffset: CGFloat = 24
        static let imageQROffset: CGFloat = 72
        static let bottomOffset: CGFloat = 40
    }
}
