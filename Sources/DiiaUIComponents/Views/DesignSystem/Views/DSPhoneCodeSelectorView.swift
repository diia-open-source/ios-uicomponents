
import UIKit

public final class DSPhoneCodeSelectorViewModel {
    public let icon: String
    public let value: String
    public let isEditable: Bool
    
    public init(model: DSPhoneCodeModel, isEditable: Bool) {
        self.icon = model.icon
        self.value = model.label
        self.isEditable = isEditable
    }
}

/// design_system_code: inputPhoneMlc
public final class DSPhoneCodeSelectorView: BaseCodeView {
    
    // MARK: - Subviews
    private let flagLabel = UILabel().withParameters(font: FontBook.bigText)
    private let phoneCodeLabel = UILabel().withParameters(font: FontBook.bigText)
    private let arrowImageView = UIImageView().withSize(Constants.arrowImageSize)
    private let bottomDivider = DSDividerLineView()
    
    // MARK: - Init
    public override func setupSubviews() {
        arrowImageView.image = R.image.arrowRight.image?.withRenderingMode(.alwaysTemplate)
        flagLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        let contentStack = UIStackView.create(
            .horizontal,
            views: [flagLabel, phoneCodeLabel, arrowImageView],
            spacing: Constants.contentSpacing,
            alignment: .center)
        stack([contentStack, bottomDivider],
              spacing: Constants.dividerSpacing)
        
        setupUI()
        setupAccessibility()
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DSPhoneCodeSelectorViewModel) {
        flagLabel.text = viewModel.icon
        flagLabel.accessibilityLabel = viewModel.icon
        phoneCodeLabel.text = viewModel.value
        phoneCodeLabel.accessibilityLabel = viewModel.value
        arrowImageView.tintColor = viewModel.isEditable ? .black : .lightGray
        bottomDivider.backgroundColor = viewModel.isEditable ? .black : .lightGray
    }
    
    public func setupUI(dividerColor: UIColor = .statusGray) {
        bottomDivider.setupUI(color: dividerColor)
    }
    
    // MARK: - Private methods
    private func setupAccessibility() {
        isAccessibilityElement = false
        
        flagLabel.isAccessibilityElement = true
        flagLabel.accessibilityTraits = .staticText
        
        phoneCodeLabel.isAccessibilityElement = true
        phoneCodeLabel.accessibilityTraits = .staticText
        
        accessibilityElements = [flagLabel, phoneCodeLabel]
    }
}

// MARK: - Constants
private extension DSPhoneCodeSelectorView {
    enum Constants {
        static let arrowImageSize: CGSize = .init(width: 8, height: 8)
        static let dividerSpacing: CGFloat = 8
        static let contentSpacing: CGFloat = 4
    }
}
