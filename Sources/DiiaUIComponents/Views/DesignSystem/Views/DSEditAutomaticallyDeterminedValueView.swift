
import UIKit

/// design_system_code: editAutomaticallyDeterminedValueOrg

public struct DSEditAutomaticallyDeterminedValueViewModel {
    public let title: String?
    public let label: String?
    public let value: String?
    public let inputMlc: TitledTextFieldViewModel
    public let componentId: String?
    
    public init(title: String?, label: String?, value: String?, inputMlc: TitledTextFieldViewModel, componentId: String? = nil) {
        self.title = title
        self.label = label
        self.value = value
        self.inputMlc = inputMlc
        self.componentId = componentId
    }
}

public final class DSEditAutomaticallyDeterminedValueView: BaseCodeView {
    private let titleLabel = UILabel().withParameters(font: FontBook.usualFont)
    private let nameLabel = UILabel().withParameters(font: FontBook.statusFont)
    private let valueLabel = UILabel().withParameters(font: FontBook.bigText, textColor: Constants.valueTextColor)
    private let stackLabelsViewBox = BoxView(subview: UIStackView.create(spacing: Constants.smallOffset))
        .withConstraints(insets: .init(horizontal: Constants.offset))
    private let inputMlcFieldBox = BoxView(subview: TitledMultilineTextView())
        .withConstraints(insets: .init(horizontal: Constants.offset))
    
    private let spacerView = UIView().withHeight(Constants.lineHeight)
    private let mainStackView = UIStackView.create(spacing: Constants.offset)
    
    public override func setupSubviews() {
        setupUI()
        stackLabelsViewBox.subview.addArrangedSubviews([titleLabel, nameLabel, valueLabel])
        stackLabelsViewBox.subview.setCustomSpacing(Constants.offset, after: titleLabel)
        
        addSubview(mainStackView)
        mainStackView.addArrangedSubviews([stackLabelsViewBox, spacerView, inputMlcFieldBox])
        mainStackView.fillSuperview(padding: .init(vertical: Constants.offset))
    }
    
    private func setupUI() {
        layer.cornerRadius = Constants.cornerRadius
        backgroundColor = .white
        spacerView.backgroundColor = UIColor.onboardingBottomColor
        inputMlcFieldBox.subview.setupUI(titleFont: FontBook.statusFont,
                                         textFont: FontBook.bigText,
                                         errorFont: FontBook.statusFont)
    }
    
    public func configure(for model: DSEditAutomaticallyDeterminedValueViewModel) {
        accessibilityIdentifier = model.componentId
        
        titleLabel.text = model.title
        nameLabel.text = model.label
        valueLabel.text = model.value
        
        let isTitleHide = model.title == nil || model.title?.isEmpty == true
        let isLabelHide = model.label == nil || model.label?.isEmpty == true
        let isValueHide = model.value == nil || model.value?.isEmpty == true
        
        stackLabelsViewBox.isHidden = isTitleHide && isLabelHide && isValueHide
        spacerView.isHidden = isLabelHide && isValueHide
        
        titleLabel.isHidden = isTitleHide
        nameLabel.isHidden = isLabelHide
        valueLabel.isHidden = isValueHide
        
        inputMlcFieldBox.subview.configure(viewModel: model.inputMlc)
        inputMlcFieldBox.subview.validate()
    }
    
}

extension DSEditAutomaticallyDeterminedValueView {
    enum Constants {
        static let valueTextColor: UIColor = .black.withAlphaComponent(0.3)
        static let cornerRadius: CGFloat = 8
        static let smallOffset: CGFloat = 8
        static let offset: CGFloat = 16
        static let lineHeight: CGFloat = 1
    }
}
