
import UIKit
import DiiaCommonTypes

public class DSUserCardViewModel {
    public let componentId: String?
    public let label: String
    public let description: String?
    public var userImage: UIImage?
    public var onClick: Callback?
    
    public init(model: DSUserCardModel) {
        self.componentId = model.componentId
        self.label = model.label
        self.description = model.description
        
        if model.userPictureAtm.useDocPhoto ?? false, let userPhoto = model.userPictureAtm.userPhoto {
            self.userImage = .createWithBase64String(userPhoto)
        } else if let imageCode = model.userPictureAtm.defaultImageCode {
            self.userImage = UIImage(named: imageCode.rawValue)
        }
    }
}

/// design_system_code: userCardMlc
public class DSUserCardView: BaseCodeView {
    private let userImageView: UIImageView = UIImageView().withSize(Constants.imageSize)
    private let nameLabel = UILabel().withParameters(font: FontBook.cardsHeadingFont)
    private let detailsLabel = UILabel().withParameters(font: FontBook.usualFont, textColor: Constants.detailsColor)
    
    // MARK: - Properties
    private var viewModel: DSUserCardViewModel?
    
    // MARK: - Life Cycle
    public override func setupSubviews() {
        userImageView.layer.cornerRadius = Constants.imageSize.height / 2
        userImageView.layer.masksToBounds = true
        userImageView.backgroundColor = .white
        userImageView.contentMode = .scaleAspectFit
        
        let infoStack = UIStackView.create(
            views: [nameLabel, detailsLabel],
            spacing: Constants.infoSpacing,
            alignment: .center)
        stack([userImageView, infoStack],
              spacing: Constants.mainSpacing,
              alignment: .center,
              padding: Constants.contentPadding)
        
        addTapGestureRecognizer()
    }
    
    // MARK: - Private Methods
    public func configure(with viewModel: DSUserCardViewModel) {
        self.viewModel = viewModel
        accessibilityIdentifier = viewModel.componentId
        userImageView.image = viewModel.userImage
        nameLabel.text = viewModel.label
        detailsLabel.text = viewModel.description
    }
    
    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        userImageView.addGestureRecognizer(tap)
        userImageView.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    @objc private func onClick() {
        viewModel?.onClick?()
    }
}

// MARK: - Constants
extension DSUserCardView {
    private enum Constants {
        static let imageSize = CGSize(width: 140, height: 140)
        static let contentPadding = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        static let detailsColor: UIColor = .black.withAlphaComponent(0.5)
        static let mainSpacing: CGFloat = 16
        static let infoSpacing: CGFloat = 8
    }
}
