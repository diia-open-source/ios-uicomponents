
import UIKit
import DiiaCommonTypes

public struct DSLinkSharingOrgModel: Codable {
    public let componentId: String
    public let text: String?
    public let linkSharingMlc: DSLinkSharingMlcModel
    public let description: String?
    public let btnIconPlainGroupMlc: DSBtnIconPlainGroupMlc
}

public class DSLinkSharingOrgViewModel {
    public let componentId: String
    public let text: String?
    public let linkSharingMlc: DSLinkSharingMlcModel
    public let description: String?
    public let iconButtonViewModels: [IconedLoadingStateViewModel]
    
    public init(
        componentId: String,
        text: String?,
        linkSharingMlc: DSLinkSharingMlcModel,
        description: String?,
        iconButtonViewModels: [IconedLoadingStateViewModel]
    ) {
        self.componentId = componentId
        self.text = text
        self.linkSharingMlc = linkSharingMlc
        self.description = description
        self.iconButtonViewModels = iconButtonViewModels
    }
}

/// design_system_code: linkSharingOrg
public class DSLinkSharingOrgView: BaseCodeView {
    
    // MARK: - Subviews
    private let textLabel = UILabel().withParameters(font: FontBook.usualFont, numberOfLines: Constants.textNumberOfLines, textAlignment: .center, lineBreakMode: .byTruncatingTail)
    private let linkSharingView = DSLinkSharingMlcView()
    private let descriptionLabel = UILabel().withParameters(font: FontBook.statusFont, textColor: .black540, numberOfLines: Constants.descriptionNumberOfLines, textAlignment: .center, lineBreakMode: .byTruncatingTail)
    private let borderedActionsView = BorderedActionsView()
    
    // MARK: - Properties
    private var viewModel: DSLinkSharingOrgViewModel?
    
    // MARK: - Init
    public override func setupSubviews() {
        withHeight(Constants.viewHeight)
        backgroundColor = .clear
        
        let separatorView = DSDividerLineView()
        separatorView.setupUI(height: Constants.separatorHeight, color: Constants.separatorColor)
        let textLabelContainer = UIView()
        textLabelContainer.addSubview(textLabel)
        addSubviews([
            textLabelContainer,
            linkSharingView,
            separatorView,
            descriptionLabel,
            borderedActionsView
        ])
        textLabel.fillSuperview()
        textLabelContainer.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, size: Constants.textLabelContainerSize)
        linkSharingView.anchor(top: textLabel.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: Constants.linkSharingViewPaddings)
        separatorView.anchor(top: linkSharingView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: Constants.separatorViewPaddings)
        descriptionLabel.anchor(top: linkSharingView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: Constants.descriptionLabelPaddings)
        borderedActionsView.anchor(leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DSLinkSharingOrgViewModel) {
        self.viewModel = viewModel
        
        textLabel.text = viewModel.text ?? .empty
        linkSharingView.configure(with: viewModel.linkSharingMlc)
        descriptionLabel.text = viewModel.description ?? .empty
        borderedActionsView.configureView(with: viewModel.iconButtonViewModels)
    }
}

// MARK: - Constants
private extension DSLinkSharingOrgView {
    enum Constants {
        static let viewHeight: CGFloat = 332
        static let separatorHeight: CGFloat = 1
        static let separatorColor = UIColor("#C5D9E9")
        static let textNumberOfLines = 3
        static let descriptionNumberOfLines = 1
        static let textLabelContainerSize = CGSize(width: .zero, height: 48)
        static let linkSharingViewPaddings = UIEdgeInsets(top: 50, left: .zero, bottom: .zero, right: .zero)
        static let descriptionLabelPaddings = UIEdgeInsets(top: 16, left: .zero, bottom: .zero, right: .zero)
        static let separatorViewPaddings = UIEdgeInsets(top: 8, left: .zero, bottom: .zero, right: .zero)
    }
}
