import UIKit

/// design_system_code: userCardMlc
public struct DSUserCardViewModel {
    public let componentId: String?
    public let userPicture: UIImage
    public let label: String
    public let description: String?
    public var onClick: (() -> Void)
}

public class DSUserCardView: BaseCodeView {
    private let userImageView: UIImageView = UIImageView().withSize(Constants.imageSize)
    private let nameLabel = UILabel().withParameters(font: FontBook.cardsHeadingFont)
    private let detailsLabel = UILabel().withParameters(
        font: FontBook.usualFont,
        textColor: Constants.detailsColor)
    
    // MARK: - Properties
    private var viewModel: DSUserCardViewModel?
    
    // MARK: - Life Cycle
    public override func setupSubviews() {
        userImageView.layer.cornerRadius = Constants.imageSize.height / 2
        
        let infoStack = UIStackView.create(
            views: [nameLabel, detailsLabel],
            spacing: Constants.infoSpacing,
            alignment: .center)
        stack([userImageView, infoStack],
              spacing: Constants.mainSpacing,
              alignment: .center)
        
        addTapGestureRecognizer()
    }
    
    // MARK: - Private Methods
    public func configure(with viewModel: DSUserCardViewModel) {
        self.viewModel = viewModel
        accessibilityIdentifier = viewModel.componentId
        userImageView.image = viewModel.userPicture
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
        viewModel?.onClick()
    }
}

// MARK: - Constants
extension DSUserCardView {
    private enum Constants {
        static let imageSize = CGSize(width: 140, height: 140)
        static let detailsColor: UIColor = .black.withAlphaComponent(0.5)
        static let mainSpacing: CGFloat = 16
        static let infoSpacing: CGFloat = 8
    }
}
