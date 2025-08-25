
import UIKit
import DiiaCommonTypes

public class ChecklistItemViewModel: NSObject {
    public let code: String?
    public let inputData: AnyCodable?
    public let largeLogoRight: String?
    public let logoRight: String?
    public let title: String
    public let details: String?
    public let rightInfo: String?
    public let isAvailable: Bool
    @objc public dynamic var isSelected: Bool
    public var onClick: (() -> Void)?
    public var componentId: String?
    
    public init(code: String? = nil,
                title: String,
                details: String? = nil,
                rightInfo: String? = nil,
                largeLogoRight: String? = nil,
                logoRight: String? = nil,
                isAvailable: Bool = true,
                isSelected: Bool = false,
                inputData: AnyCodable? = nil,
                componentId: String? = nil) {
        self.code = code
        self.title = title
        self.details = details
        self.largeLogoRight = largeLogoRight
        self.logoRight = logoRight
        self.rightInfo = rightInfo
        self.isAvailable = isAvailable
        self.isSelected = isSelected
        self.inputData = inputData
        self.componentId = componentId
    }
    
    public func getInputData() -> AnyCodable? {
        if let inputData = inputData {
            return inputData
        } else if let code = code {
            return .string(code)
        } else if let componentId = componentId {
            return .string(componentId)
        } else {
            return nil
        }
    }
}

public class ChecklistItemView: BaseCodeView {
    private let selectionIcon = UIImageView()
    private let titleLabel = UILabel()
    private let detailsLabel = UILabel()
    private let rightInfoLabel = UILabel().withParameters(font: FontBook.usualFont, textColor: Constants.grayTextColor)
    private let rightImage = UIImageView().withSize(Constants.rightImageSize)
    private let rightLargeImage = UIImageView().withSize(Constants.largeRightImageSize)
    
    private var observation: NSKeyValueObservation?
    private var viewModel: ChecklistItemViewModel?
    private var checkboxStyle: CheckboxStyle?
    
    public override func setupSubviews() {
        backgroundColor = .clear
        rightInfoLabel.setContentHuggingPriority(.required, for: .horizontal)
        selectionIcon.withSize(Constants.selectionIconSize)
        setupUI(titleFont: FontBook.usualFont,
                titleColor: .black,
                detailsFont: FontBook.usualFont,
                detailsTextColor: Constants.grayTextColor,
                rightInfoFont: FontBook.usualFont,
                rightInfoColor: Constants.grayTextColor)
        
        let titleLabelWrapper = BoxView(subview: titleLabel)
            .withConstraints(insets: Constants.contentInsets)
        
        let topStackView = UIStackView.create(
            .horizontal,
            views: [titleLabelWrapper, rightInfoLabel],
            spacing: Constants.stackViewSpacing,
            alignment: .top
        )
        
        let centralStackView = UIStackView.create(
            views: [topStackView, detailsLabel],
            spacing: Constants.titleSpacing,
            alignment: .fill
        )
        
        hstack(selectionIcon,
               centralStackView,
               rightImage,
               rightLargeImage,
               spacing: Constants.stackViewSpacing,
               alignment: .top)
        rightLargeImage.layer.cornerRadius = Constants.largeRightCorner
        rightLargeImage.layer.borderWidth = Constants.largeImageBorderWidth
        rightLargeImage.layer.borderColor = Constants.largeImageBorderColor
        rightLargeImage.isHidden = true
        rightImage.isHidden = true
        
        addTapGestureRecognizer()
    }
    
    // MARK: - Public methods
    public func configure(with viewModel: ChecklistItemViewModel) {
        accessibilityIdentifier = viewModel.componentId
        accessibilityLabel = viewModel.title
        
        self.viewModel = viewModel
        
        titleLabel.text = viewModel.title
        
        detailsLabel.isHidden = viewModel.details == nil
        detailsLabel.text = viewModel.details
        
        rightInfoLabel.isHidden = viewModel.rightInfo == nil
        rightInfoLabel.text = viewModel.rightInfo
        
        if let largeLogoRight = viewModel.largeLogoRight {
            let imageProvider = UIComponentsConfiguration.shared.imageProvider
            rightLargeImage.image = imageProvider?.imageForCode(imageCode: largeLogoRight)
            rightLargeImage.isHidden = false
        }
        
        if let logoRight = viewModel.logoRight {
            let imageProvider = UIComponentsConfiguration.shared.imageProvider
            rightImage.image = imageProvider?.imageForCode(imageCode: logoRight)
            rightImage.contentMode = .scaleAspectFit
            rightImage.isHidden = false
        }
        
        observation = viewModel.observe(\.isSelected, onChange: { [weak self] isSelected in
            guard let self = self else { return }
            self.setSelection(state: isSelected)
            
            accessibilityTraits = isSelected ? [.button, .selected] : [.button]
        })
        
        setViewAvailability(viewModel.isAvailable)
        setupAccessibility()
    }
    
    public func setupUI(checkboxStyle: CheckboxStyle? = nil,
                        titleFont: UIFont? = nil,
                        titleColor: UIColor? = nil,
                        detailsFont: UIFont? = nil,
                        detailsTextColor: UIColor? = nil,
                        rightInfoFont: UIFont? = nil,
                        rightInfoColor: UIColor? = nil) {
        self.checkboxStyle = checkboxStyle
        setSelection(state: viewModel?.isSelected ?? false)
        
        titleLabel.withParameters(
            font: titleFont ?? titleLabel.font,
            textColor: titleColor ?? titleLabel.textColor
        )
        detailsLabel.withParameters(
            font: detailsFont ?? detailsLabel.font,
            textColor: detailsTextColor ?? detailsLabel.textColor
        )
        
        rightInfoLabel.textAlignment = .right
        rightInfoLabel.withParameters(
            font: rightInfoFont ?? rightInfoLabel.font,
            textColor: rightInfoColor ?? rightInfoLabel.textColor
        )
    }
    
    public func setSelection(state isSelected: Bool) {
        guard let checkboxStyle = checkboxStyle else { return }
        if viewModel?.isAvailable == false && isSelected {
            selectionIcon.image = checkboxStyle.disableSelectedImage
        } else {
            selectionIcon.image = isSelected ? checkboxStyle.selectedImage : checkboxStyle.disabledImage
        }
    }
    
    // MARK: - Actions
    @objc private func onClick() {
        viewModel?.onClick?()
    }
    
    // MARK: - Private methods
    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    private func setViewAvailability(_ isActive: Bool) {
        self.isUserInteractionEnabled = isActive
        selectionIcon.alpha = isActive ? Constants.activeIconAlpha : Constants.inactiveIconAlpha
        setupUI(titleColor: isActive ? .black : Constants.grayTextColor)
    }
    
    private func setupAccessibility() {
        isAccessibilityElement = true
    }
}

// MARK: - Constants
extension ChecklistItemView {
    private enum Constants {
        static let contentInsets = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
        static let selectionIconSize = CGSize(width: 20, height: 20)
        static let titleSpacing: CGFloat = 8
        static let stackViewSpacing: CGFloat = 16
        static let grayTextColor = UIColor.statusGray
        static let inactiveIconAlpha: CGFloat = 0.3
        static let activeIconAlpha: CGFloat = 1.0
        static let rightImageSize = CGSize(width: 32, height: 24)
        static let largeRightImageSize = CGSize(width: 56, height: 36)
        static let largeRightCorner: CGFloat = 4
        static let largeImageBorderColor: CGColor = UIColor(hex: 0x0805A8).withAlphaComponent(0.04).cgColor
        static let largeImageBorderWidth: CGFloat = 0.5
    }
}
