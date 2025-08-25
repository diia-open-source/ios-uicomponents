
import UIKit

// MARK: - Model
public struct DSItemReadModel: Codable {
    let componentId: String?
    let label: String?
    let value: String?
    let iconRight: DSIconModel?
}

// MARK: - ViewModel
public struct DSItemReadViewModel {
    let componentId: String?
    let label: String?
    let value: String?
    let icon: UIImage?
}

/// design_system_code: itemReadMlc
public class DSItemReadView: BaseCodeView {
    private let titleLabel = UILabel().withParameters(font: FontBook.usualFont)
    private let detailsLabel = UILabel().withParameters(font: FontBook.bigText)
    private let iconRightView: UIImageView = UIImageView().withSize(Constants.iconRightSize)
    
    public override func setupSubviews() {
        let textStackView = UIStackView.create(
            views: [titleLabel, detailsLabel],
            spacing: Constants.vSpacing
        )
        hstack(
            textStackView, iconRightView,
            spacing: Constants.hSpacing,
            alignment: .center,
            padding: Constants.contentPadding
        )
    }
    
    public func configure(with viewModel: DSItemReadViewModel) {
        accessibilityIdentifier = viewModel.componentId
        titleLabel.isHidden = viewModel.label == nil
        if let label = viewModel.label {
            titleLabel.text = label
        }
        detailsLabel.isHidden = viewModel.value == nil
        if let value = viewModel.value {
            detailsLabel.text = value
        }
        iconRightView.isHidden = viewModel.icon == nil
        if let icon = viewModel.icon {
            iconRightView.image = icon
        }
    }
}

// MARK: - Constants
private extension DSItemReadView {
    enum Constants {
        static let iconRightSize = CGSize(width: 24, height: 24)
        static let vSpacing: CGFloat = 4
        static let hSpacing: CGFloat = 8
        static let contentPadding = UIEdgeInsets(top: 8, left: .zero, bottom: 8, right: .zero)
    }
}
