import UIKit
import DiiaCommonTypes

public struct DSNavigationBarViewModel {
    public let title: String?
    public let backAction: Callback?
    public let action: Action?
    
    public init(title: String?,
                backAction: Callback? = nil,
                action: Action? = nil) {
        self.title = title
        self.backAction = backAction
        self.action = action
    }
}

/// design_system_code: navigationPanelMlc
public class DSNavigationBarView: BaseCodeView {
    
    private var backButton = ActionButton(action: .init(title: nil, image: R.image.menu_back.image, callback: {}), type: .icon)
    private let backButtonContainer = UIView()
    private var titleLabel = UILabel().withParameters(font: FontBook.smallHeadingFont)
    private var actionButton = ActionButton()
    
    public override func setupSubviews() {
        backgroundColor = .clear
        backButtonContainer.backgroundColor = .clear
        
        backButtonContainer.addSubview(backButton)
        backButton.anchor(
            top: backButtonContainer.topAnchor,
            leading: backButtonContainer.leadingAnchor,
            bottom: backButtonContainer.bottomAnchor,
            trailing: backButtonContainer.trailingAnchor,
            size: Constants.backButtonSize)
        
        actionButton.iconRenderingMode = .alwaysOriginal
        backButton.iconRenderingMode = .alwaysTemplate
        
        backButton.tintColor = .black
        
        actionButton.withSize(Constants.buttonSize)
        
        titleLabel.numberOfLines = Constants.maxLineNumber
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, actionButton])
        stackView.alignment = .top
        stackView.spacing = Constants.stackSpacing
        hstack(backButtonContainer, stackView, spacing: Constants.viewSpacing, alignment: .top, padding: Constants.viewInsets)
    }
    
    public func configure(viewModel: DSNavigationBarViewModel) {
        if let title = viewModel.title {
            titleLabel.setTextWithCurrentAttributes(text: title, font: FontBook.smallHeadingFont, lineHeight: Constants.lineHeight)
        }
        
        if let backAction = viewModel.backAction {
            backButton.action = .init(title: nil, image: R.image.menu_back.image, callback: backAction)
        }
        backButtonContainer.isHidden = viewModel.backAction == nil
        actionButton.isHidden = viewModel.action == nil
        
        if let action = viewModel.action {
            actionButton.action = action
        }
    }
    
    public func setupTitle(_ title: String, font: UIFont? = nil) {
        titleLabel.setTextWithCurrentAttributes(text: title, font: font, lineHeight: Constants.lineHeight)
    }
    
}

private extension DSNavigationBarView {
    enum Constants {
        static let viewInsets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        static let buttonSize: CGSize = .init(width: 32, height: 32)
        static let backButtonSize: CGSize = .init(width: 28, height: 28)
        static let viewSpacing: CGFloat = 8
        static let stackSpacing: CGFloat = 16
        static let lineHeight: CGFloat = 24
        static let maxLineNumber: Int = 3
    }
}
