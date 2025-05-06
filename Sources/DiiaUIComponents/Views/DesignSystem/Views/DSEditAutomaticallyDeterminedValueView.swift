
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
    private let stackLabelsView = UIStackView.create(spacing: Constants.smallOffset)
    private let inputMlcField = TitledMultilineTextView()
    
    public override func setupSubviews() {
        setupUI()
        stackLabelsView.addArrangedSubviews([titleLabel, nameLabel, valueLabel])
        stackLabelsView.setCustomSpacing(Constants.offset, after: titleLabel)
        addSubview(stackLabelsView)
        addSubview(inputMlcField)
        
        stackLabelsView.anchor(top: topAnchor,
                          leading: leadingAnchor,
                          trailing: trailingAnchor,
                          padding: .init(top: Constants.offset,
                                         left: Constants.offset,
                                         bottom: .zero,
                                         right: Constants.offset))
        let spacerView = UIView()
        spacerView.backgroundColor = UIColor.onboardingBottomColor
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        addSubview(spacerView)
        
        spacerView.anchor(top: stackLabelsView.bottomAnchor,
                          leading: leadingAnchor,
                          trailing: trailingAnchor,
                          padding: .init(top: Constants.offset, left: .zero, bottom: .zero, right: .zero),
                          size: CGSize(width: .zero, height: Constants.lineHeight))
        
        inputMlcField.anchor(top: spacerView.bottomAnchor,
                             leading: leadingAnchor,
                             bottom: bottomAnchor,
                             trailing: trailingAnchor,
                             padding: .init(top: Constants.offset, left: Constants.offset, bottom: Constants.offset, right: Constants.offset))
    }
    
    private func setupUI() {
        layer.cornerRadius = Constants.cornerRadius
        backgroundColor = .white
        inputMlcField.setupUI(titleFont: FontBook.statusFont,
                              textFont: FontBook.bigText,
                              errorFont: FontBook.statusFont)
    }
    
    public func configure(for model: DSEditAutomaticallyDeterminedValueViewModel) {
        accessibilityIdentifier = model.componentId
        titleLabel.text = model.title
        nameLabel.text = model.label
        valueLabel.text = model.value
        
        titleLabel.isHidden = model.title == nil || model.title?.isEmpty == true
        nameLabel.isHidden = model.label == nil || model.label?.isEmpty == true
        valueLabel.isHidden = model.value == nil || model.value?.isEmpty == true
        
        inputMlcField.configure(viewModel: model.inputMlc)
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
