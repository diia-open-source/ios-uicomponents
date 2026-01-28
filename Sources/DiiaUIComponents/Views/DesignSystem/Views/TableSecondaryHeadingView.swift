
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
    private var viewModel: TableSecondaryHeadingViewModel?
    
    override func setupSubviews() {
        headingButton.tintColor = .black
        headingButton.isHidden = true
        headingButton.withSize(Constants.buttonSize)
        
        let stackView = UIStackView(arrangedSubviews: [label, headingButton])
        stackView.axis = .horizontal
        stackView.spacing = Constants.stackSpacing
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.fillSuperview()
        
        setupAccessibility()
    }
    
    func configure(with viewModel: TableSecondaryHeadingViewModel) {
        self.viewModel = viewModel
        self.accessibilityIdentifier = viewModel.headingModel.componentId
        
        label.text = viewModel.headingModel.label
        label.accessibilityLabel = viewModel.headingModel.label
        
        if let iconModel = viewModel.headingModel.icon, let callback = viewModel.onClickAction {
            let imageProvider = UIComponentsConfiguration.shared.imageProvider
            headingButton.accessibilityLabel = iconModel.accessibilityDescription
            headingButton.action = Action(iconName: imageProvider.imageNameForCode(imageCode: iconModel.code),
                                          callback: callback)
        }
        headingButton.isHidden = viewModel.headingModel.icon == nil
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
