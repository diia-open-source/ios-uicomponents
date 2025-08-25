
import UIKit
import DiiaCommonTypes

public class DSMediaTitleViewModel {
    public let title: String
    public let secondaryLabel: String
    public let button: IconedLoadingStateViewModel
    
    public init(model: DSMediaTitleModel, action: @escaping Callback) {
        self.title = model.title
        self.secondaryLabel = model.secondaryLabel
        self.button = IconedLoadingStateViewModel(
            name: model.btnPlainIconAtm.label,
            image: UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: model.btnPlainIconAtm.icon) ?? UIImage(),
            clickHandler: action,
            componentId: model.btnPlainIconAtm.componentId)
    }
}

/// design_system_code: mediaTitleOrg
final public class DSMediaTitleView: BaseCodeView {
    private let titleLabel = UILabel().withParameters(font: FontBook.cardsHeadingFont)
    private let secondaryLabel = UILabel().withParameters(font: FontBook.usualFont, textColor: .black600, numberOfLines: 1)
    private let plainButton = IconedLoadingStateView()
    
    private var viewModel: DSMediaTitleViewModel?
    
    override public func setupSubviews() {
        let topView = UIView()
        topView.addSubview(secondaryLabel)
        topView.addSubview(plainButton)
        secondaryLabel.centerYAnchor
                      .constraint(equalTo: topView.centerYAnchor)
                      .isActive = true
        secondaryLabel.anchor(leading: topView.leadingAnchor,
                              padding: Constants.labelPadding)
        plainButton.withHeight(Constants.buttonHeight)
        plainButton.anchor(top: topView.topAnchor,
                           bottom: topView.bottomAnchor,
                           trailing: topView.trailingAnchor,
                           padding: Constants.buttonPadding)
        
        let divider = UIView().withHeight(Constants.dividerHeight)
        divider.backgroundColor = Constants.dividerColor
        
        stack([UIStackView.create(views: [topView, divider]), titleLabel],
              spacing: Constants.contentStackSpacing)
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DSMediaTitleViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        secondaryLabel.text = viewModel.secondaryLabel
        plainButton.configure(viewModel: viewModel.button)
    }
}

// MARK: - Constants
private extension DSMediaTitleView {
    enum Constants {
        static let secondaryTextColor: UIColor = .black.withAlphaComponent(0.5)
        static let topStackSpacing: CGFloat = 16
        static let dividerHeight: CGFloat = 1
        static let dividerColor: UIColor = .black.withAlphaComponent(0.1)
        static let contentStackSpacing: CGFloat = 24
        static let buttonHeight: CGFloat = 56
        static let buttonPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        static let labelPadding = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
    }
}
