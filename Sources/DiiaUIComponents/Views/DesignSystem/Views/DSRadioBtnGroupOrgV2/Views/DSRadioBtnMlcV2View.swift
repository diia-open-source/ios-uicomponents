
import UIKit
import DiiaCommonTypes

public class DSRadioBtnMlcV2ViewModel: NSObject {
    public let componentId: String
    public let code: String
    public let iconRight: DSIconModel?
    public let iconLeft: DSIconModel?
    public let label: String
    public let details: String?
    public let status: String?
    public let isAvailable: Bool
    public var isSelected: Observable<Bool>
    public var onClick: Callback?
    
    public init(componentId: String,
                code: String,
                iconRight: DSIconModel?,
                iconLeft: DSIconModel?,
                label: String,
                status: String?,
                details: String?,
                isAvailable: Bool,
                isSelected: Observable<Bool>,
                onClick: Callback? = nil) {
        self.componentId = componentId
        self.code = code
        self.iconRight = iconRight
        self.iconLeft = iconLeft
        self.label = label
        self.status = status
        self.details = details
        self.isAvailable = isAvailable
        self.isSelected = isSelected
        self.onClick = onClick
    }
}

final public class DSRadioBtnMlcV2View: BaseCodeView {
    private let mainHStack = UIStackView.create(.horizontal,spacing: Constants.bigSpacing, alignment: .top)
    private let contentHStack = UIStackView.create(.horizontal, spacing: Constants.smallSpacing, alignment: .top)
    private let iconLabelStack = UIStackView.create(.horizontal, spacing: Constants.smallSpacing)
    private let contentLabelStack = UIStackView.create(.vertical, spacing: Constants.vStackSpacing)
    private let iconStatusStack = UIStackView.create(.horizontal, spacing: Constants.smallSpacing)
    private let titleLabel = UILabel().withParameters(font: FontBook.bigText, textColor: .black)
    private let descriptionLabel = UILabel().withParameters(font: FontBook.usualFont,
                                                            textColor: Constants.descriptionLabelColor)
    private let statusLabel = UILabel().withParameters(font: FontBook.usualFont,
                                                       textColor: Constants.statusLabelColor)
    private let iconLeft = DSIconView()
    private let iconRight = DSIconView()
    private let selectionIcon = UIImageView()
    
    private var viewModel: DSRadioBtnMlcV2ViewModel?
    
    public override func setupSubviews() {
        addSubview(mainHStack)
        mainHStack.fillSuperview(padding: Constants.paddings)
        iconLeft.withSize(Constants.iconLeftSize)
        iconRight.withSize(Constants.iconRightSize)
        selectionIcon.withSize(Constants.selectionIcon)
        selectionIcon.tintColor = .black

        iconLabelStack.addArrangedSubviews([
            iconLeft,
            titleLabel
        ])
        
        contentLabelStack.addArrangedSubviews([
            iconLabelStack,
            descriptionLabel
        ])
      
        iconStatusStack.addArrangedSubviews([
            iconRight,
            statusLabel
        ])
        
        contentHStack.addArrangedSubviews([
            contentLabelStack,
            iconStatusStack
        ])
        
        mainHStack.addArrangedSubviews([
            selectionIcon,
            contentHStack
        ])
        layer.cornerRadius = Constants.cornerRadius
        titleLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0
    }
    
    public func configure(with viewModel: DSRadioBtnMlcV2ViewModel) {
        self.viewModel = viewModel
        accessibilityIdentifier = viewModel.componentId
        accessibilityLabel = viewModel.label
        
        titleLabel.text = viewModel.label
        descriptionLabel.isHidden = viewModel.details == nil
        descriptionLabel.text = viewModel.details
        statusLabel.isHidden = viewModel.status == nil
        statusLabel.text = viewModel.status
        
        iconLeft.isHidden = viewModel.iconLeft == nil
        if let iconLeft = viewModel.iconLeft {
            self.iconLeft.setIcon(iconLeft)
        }
        
        iconRight.isHidden = viewModel.iconRight == nil
        if let iconRight = viewModel.iconRight {
            self.iconRight.setIcon(iconRight)
        }
        iconStatusStack.isHidden = viewModel.status == nil && viewModel.iconRight == nil
        
        viewModel.isSelected.removeObserver(observer: self)
        viewModel.isSelected.observe(observer: self) { [weak self] isSelected in
            self?.setState(isSelected)
        }
        
        tapGestureRecognizer { [weak self] in
            guard viewModel.isAvailable else { return }
            self?.viewModel?.onClick?()
        }
    }
    
    private func setState(_ isSelected: Bool) {
        guard let viewModel = self.viewModel else { return }
        selectionIcon.image = isSelected ? R.image.radioCheckbox.image?.withRenderingMode(.alwaysTemplate) : R.image.emptyChecboxBlack.image?.withRenderingMode(.alwaysTemplate)
        alpha = viewModel.isAvailable ? 1.0 : 0.4
        isUserInteractionEnabled = viewModel.isAvailable
        backgroundColor = isSelected ? Constants.selectedColor : Constants.defaultColor
    }
}

private extension DSRadioBtnMlcV2View {
    enum Constants {
        static let descriptionLabelColor: UIColor = .black.withAlphaComponent(0.6)
        static let statusLabelColor: UIColor = .black.withAlphaComponent(0.5)
        static let paddings: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let iconLeftSize: CGSize = .init(width: 24, height: 24)
        static let iconRightSize: CGSize = .init(width: 30, height: 20)
        static let selectionIcon: CGSize = .init(width: 20, height: 20)
        static let cornerRadius: CGFloat = 13
        static let defaultColor: UIColor = .white
        static let selectedColor: UIColor = .init("#F1F6F6")
        static let bigSpacing: CGFloat = 16
        static let smallSpacing: CGFloat = 8
        static let vStackSpacing: CGFloat = 4
    }
}
