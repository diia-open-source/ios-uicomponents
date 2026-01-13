
import UIKit
import DiiaCommonTypes

public struct DSListWidgetItemModel: Codable {
    public let componentId: String?
    public let id: String?
    public let label: String
    public let description: String?
    public let iconLeft: String?
    public let iconRight: String?
    public let state: String?
    public let dataJson: AnyCodable?
    
    public init(
        componentId: String?,
        id: String?,
        label: String,
        description: String?,
        iconLeft: String?,
        iconRight: String?,
        state: String?,
        dataJson: AnyCodable?
    ) {
        self.componentId = componentId
        self.id = id
        self.label = label
        self.description = description
        self.iconLeft = iconLeft
        self.iconRight = iconRight
        self.state = state
        self.dataJson = dataJson
    }
}

public final class DSListWidgetItemViewModel {
    let model: DSListWidgetItemModel
    var onClick: Callback?
    
    public init(model: DSListWidgetItemModel, onClick: Callback? = nil) {
        self.model = model
        self.onClick = onClick
    }
}

/// design_system_code: listWidgetItemMlc
public final class DSListWidgetItemView: BaseCodeView {
    
    // MARK: - Subviews
    private let leftIconView: UIImageView = .init().withSize(Constants.imageSize)
    private let titleLabel: UILabel = .init().withParameters(font: FontBook.bigText)
    private let detailsLabel: UILabel = .init().withParameters(font: FontBook.usualFont, textColor: Constants.grayTextColor)
    private let rightIconView: UIImageView = .init().withSize(Constants.imageSize)
    
    // MARK: - Properties
    private var viewModel: DSListWidgetItemViewModel?
    
    // MARK: - Init
    public override func setupSubviews() {
        let infoStackView = UIStackView.create(
            views: [titleLabel, detailsLabel],
            spacing: Constants.infoSpacing,
            alignment: .leading)
        
        let contentStack = UIStackView.create(
            .horizontal,
            views: [leftIconView, infoStackView, rightIconView],
            spacing: Constants.contentSpacing,
            alignment: .center,
            padding: Constants.contentPadding)
        
        stack([contentStack, DSDividerLineView()],
              spacing: Constants.contentSpacing)
        
        initialSetup()
    }
    
    private func initialSetup() {
        backgroundColor = .clear
        addTapGestureRecognizer()
    }
    
    // MARK: - Private Methods
    public func configure(with viewModel: DSListWidgetItemViewModel) {
        self.viewModel = viewModel
        self.accessibilityIdentifier = viewModel.model.componentId
        
        leftIconView.isHidden = viewModel.model.iconLeft == nil
        if let iconLeft = viewModel.model.iconLeft {
            leftIconView.image = UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: iconLeft)
        }
        
        titleLabel.text = viewModel.model.label
        
        detailsLabel.isHidden = viewModel.model.description == nil
        if let description = viewModel.model.description {
            detailsLabel.text = description
        }
        
        rightIconView.isHidden = viewModel.model.iconRight == nil
        if let iconRight = viewModel.model.iconRight {
            rightIconView.image = UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: iconRight)
        }
    }
    
    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    @objc private func onClick() {
        viewModel?.onClick?()
    }
}

// MARK: - Constants
extension DSListWidgetItemView {
    private enum Constants {
        static let imageSize = CGSize(width: 24, height: 24)
        static let grayTextColor: UIColor = .black.withAlphaComponent(0.3)
        static let contentSpacing: CGFloat = 16
        static let infoSpacing: CGFloat = 4
        static let contentPadding = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
}
