
import UIKit
import DiiaCommonTypes

public final class DSTableItemCheckboxItemViewModel: NSObject {
    public let componentId: String?
    public let inputCode: String
    public let mandatory: Bool
    public let rows: [DSTableItemCheckboxRowModel]
    public var isSelected: Observable<Bool>
    public var isPartialSelected: Observable<Bool>
    public let isEnabled: Observable<Bool>
    public let dataJson: String?
    public var onClick: Callback?
    
    public init(model: DSTableItemCheckboxModel) {
        self.componentId = model.componentId
        self.inputCode = model.inputCode ?? model.componentId ?? .empty
        self.mandatory = model.mandatory ?? false
        self.rows = model.rows
        self.isSelected = .init(value: model.isSelected ?? false)
        self.isPartialSelected = .init(value: model.isNotFullSelected ?? false)
        self.isEnabled = .init(value: model.isEnabled ?? true)
        self.dataJson = model.dataJson
        self.onClick = nil
    }
}

/// design_system_code: tableItemCheckboxMlc
public final class DSTableItemCheckboxView: BaseCodeView {
    private let mainStack = UIStackView.create(.horizontal, spacing: Constants.horizontalSpacing, alignment: .leading)
    private let rowsStack = UIStackView.create(.vertical, spacing: Constants.rowsSpacing)
    private let checkmarkImageView: UIImageView = .init().withSize(Constants.checkmarkImageSize)
    
    private var viewModel: DSTableItemCheckboxItemViewModel?
    
    private var accessibilityTraitsSet: Set<UIAccessibilityTraits> = [.button] {
        didSet {
            accessibilityTraits = UIAccessibilityTraits(accessibilityTraitsSet)
        }
    }
    
    public override func setupSubviews() {
        checkmarkImageView.contentMode = .scaleAspectFit
        
        addSubview(mainStack)
        mainStack.addArrangedSubviews([checkmarkImageView, rowsStack])
        mainStack.fillSuperview()
        
        addTapGestureRecognizer()
        setupAccessibility()
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DSTableItemCheckboxItemViewModel) {
        self.viewModel = viewModel
        
        rowsStack.safelyRemoveArrangedSubviews()
        viewModel.rows.forEach(addRowView)
        accessibilityLabel = viewModel.rows.compactMap({ $0.textLabelAtm.label }).joined(separator: ",")
        
        viewModel.isSelected.observe(observer: self) { [weak self] _ in
            self?.updateSelectionState()
        }
        viewModel.isPartialSelected.observe(observer: self) { [weak self] _ in
            self?.updateSelectionState()
        }
        viewModel.isEnabled.observe(observer: self) { [weak self] isEnabled in
            self?.updateAvailabilityState(isEnabled: isEnabled)
        }
    }
    
    public func setupUI(titleFont: UIFont = FontBook.usualFont) {
        for (index, row) in rowsStack.arrangedSubviews.enumerated() {
            if let pairRow = row as? PairView {
                pairRow.setupUI(
                    titleFont: index == 0 ? titleFont : FontBook.usualFont,
                    titleColor: index == 0 ? DSTextLabelAtmMode.primary.textColor : DSTextLabelAtmMode.secondary.textColor)
            }
        }
    }
    
    // MARK: - Private Methods
    private func addRowView(_ model: DSTableItemCheckboxRowModel) {
        let textLabelAtm = model.textLabelAtm
        
        let rowView = PairView()
        rowView.setupUI(
            titleProportion: Constants.pairViewTitleProportion,
            titleColor: textLabelAtm.mode.textColor,
            detailsColor: textLabelAtm.mode.textColor,
            spacing: Constants.pairViewSpacing
        )
        rowView.configure(title: textLabelAtm.label,
                          details: textLabelAtm.value)
        
        rowsStack.addArrangedSubview(rowView)
    }
    
    private func setupAccessibility() {
        isAccessibilityElement = true
    }
    
    private func addTapGestureRecognizer() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapped))
        self.addGestureRecognizer(gesture)
        self.isUserInteractionEnabled = true
    }
    
    private func updateSelectionState() {
        guard let viewModel else { return }
        if viewModel.isPartialSelected.value == true {
            checkmarkImageView.image = R.image.checkbox_partialSelected.image
            return
        }
        checkmarkImageView.image = viewModel.isSelected.value ? R.image.checkbox_enabled.image : R.image.checkbox_disabled.image
        
        if viewModel.isSelected.value {
            accessibilityTraitsSet.insert(.selected)
        } else {
            accessibilityTraitsSet.remove(.selected)
        }
    }
    
    private func updateAvailabilityState(isEnabled: Bool) {
        isUserInteractionEnabled = isEnabled
        checkmarkImageView.alpha = isEnabled ? 1 : 0.3
        
        if isEnabled {
            accessibilityTraitsSet.remove(.notEnabled)
        } else {
            accessibilityTraitsSet.insert(.notEnabled)
        }
    }
    
    @objc private func onTapped() {
        guard let viewModel = viewModel else { return }
        if viewModel.isPartialSelected.value {
            viewModel.isPartialSelected.value = false
            viewModel.isSelected.value = true
        } else {
            viewModel.isSelected.value.toggle()
        }
        viewModel.onClick?()
    }
}

// MARK: - DSInputComponentProtocol
extension DSTableItemCheckboxView: DSInputComponentProtocol {
    public func isValid() -> Bool {
        guard viewModel?.mandatory == true else { return true }
        return viewModel?.isSelected.value == true
    }
    
    public func inputCode() -> String {
        return viewModel?.inputCode ?? "tableItemCheckboxMlc"
    }
    
    public func inputData() -> AnyCodable? {
        return .bool(viewModel?.isSelected.value ?? false)
    }
}

// MARK: - Constants
private extension DSTableItemCheckboxView {
    enum Constants {
        static let horizontalSpacing: CGFloat = 12
        static let pairViewSpacing: CGFloat = 12
        static let pairViewTitleProportion: CGFloat = 0.5
        static let rowsSpacing: CGFloat = 4
        static let checkmarkImageSize = CGSize(width: 20, height: 20)
    }
}
