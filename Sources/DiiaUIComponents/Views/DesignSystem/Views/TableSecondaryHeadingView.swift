
import UIKit
import DiiaCommonTypes

public struct TableSecondaryHeadingViewModel {
    public let headingModel: DSTableHeadingItemModel
    public let onClickAction: Callback?

    public init(headingModel: DSTableHeadingItemModel, onClickAction: Callback? = nil) {
        self.headingModel = headingModel
        self.onClickAction = onClickAction
    }
}

final class TableSecondaryHeadingView: BaseCodeView {
    private let label = UILabel().withParameters(font: FontBook.bigText, textColor: .black)
    private let headingButton = ActionButton(type: .icon)
    private let leftIcon = UIImageView()
    private var viewModel: TableSecondaryHeadingViewModel?
    
    override func setupSubviews() {
        headingButton.tintColor = .black
        headingButton.isHidden = true
        headingButton.withSize(Constants.buttonSize)
        leftIcon.withSize(Constants.buttonSize)
        
        let stackView = UIStackView.create(.horizontal, views: [leftIcon, label, headingButton], spacing: Constants.stackSpacing, alignment: .center)
        
        addSubview(stackView)
        stackView.fillSuperview()
        
        setupAccessibility()
    }
    
    func configure(with viewModel: TableSecondaryHeadingViewModel) {
        self.viewModel = viewModel
        self.accessibilityIdentifier = viewModel.headingModel.componentId
        
        label.text = viewModel.headingModel.label
        label.accessibilityLabel = viewModel.headingModel.label
        
        let imageProvider = UIComponentsConfiguration.shared.imageProvider
        
        headingButton.isHidden = viewModel.headingModel.icon == nil
        if let iconModel = viewModel.headingModel.icon, let callback = viewModel.onClickAction {
            headingButton.accessibilityLabel = iconModel.accessibilityDescription
            headingButton.action = Action(iconName: imageProvider.imageNameForCode(imageCode: iconModel.code),
                                          callback: callback)
        }
        leftIcon.isHidden = viewModel.headingModel.iconLeft == nil
        if let iconModel = viewModel.headingModel.iconLeft {
            leftIcon.accessibilityLabel = iconModel.accessibilityDescription
            leftIcon.image = imageProvider.imageForCode(imageCode: iconModel.code)
        }
    }
    
    private func setupAccessibility() {
        label.isAccessibilityElement = true
        label.accessibilityTraits = .staticText
        
        headingButton.isAccessibilityElement = true
        headingButton.accessibilityTraits = .button
    }
}

private extension TableSecondaryHeadingView {
    enum Constants {
        static let buttonSize = CGSize(width: 24, height: 24)
        static let stackSpacing: CGFloat = 16
    }
}
