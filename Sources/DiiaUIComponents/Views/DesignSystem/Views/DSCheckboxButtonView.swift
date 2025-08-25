
import UIKit
import DiiaCommonTypes

// MARK: - DSCheckboxButtonView
public class DSCheckboxButtonViewModel {
    public let checkboxVMs: [CheckmarkViewModel]
    public let mainButtonVM: DSLoadingButtonViewModel?
    public let strokeButtonVM: DSLoadingButtonViewModel?
    public let plainButtonVM: DSLoadingButtonViewModel?
    
    public init(checkboxVMs: [CheckmarkViewModel],
                buttonVM: DSLoadingButtonViewModel?,
                strokeButtonVM: DSLoadingButtonViewModel? = nil,
                plainButtonVM: DSLoadingButtonViewModel? = nil
    ) {
        self.checkboxVMs = checkboxVMs
        self.mainButtonVM = buttonVM
        self.strokeButtonVM = strokeButtonVM
        self.plainButtonVM = plainButtonVM
        validateButtons()
    }
    
    public func updateState(selectedCheckbox: CheckmarkViewModel, isSelected: Bool) {
        selectedCheckbox.isChecked = isSelected
        validateButtons()
    }
    
    public func validateButtons() {
        let isAllChecked = checkboxVMs.allSatisfy({ $0.isChecked })
        mainButtonVM?.state.value = isAllChecked ? .enabled : .disabled
        strokeButtonVM?.state.value = isAllChecked ? .enabled : .disabled
    }
}

public class DSCheckboxButtonView: BaseCodeView, DSInputComponentProtocol {
    
    private let checkboxStackView = UIStackView.create(views: [], spacing: Constants.spacing)
    private let primaryButton = DSPrimaryDefaultButton()
    private let plainButton = DSLoadingButton()
    private let strokeButtonBox: BoxView<DSLoadingButton> = {
        let button = DSLoadingButton()
        button.setStyle(style: .light)
        button.titleLabel?.font = FontBook.bigText
        button.contentEdgeInsets = Constants.buttonEdgeInsets
        button.withHeight(Constants.buttonHeight)
        
        let paddingBox = BoxView(subview: button).withConstraints(insets: .zero, centeredX: true)
        return paddingBox
    }()
    
    private var viewModel: DSCheckboxButtonViewModel?
    
    // MARK: - Init
    public override func setupSubviews() {
        self.layer.cornerRadius = Constants.cornerRadius
        self.withBorder(
            width: Constants.borderWidth,
            color: Constants.borderColor)
        
        primaryButton.withHeight(Constants.buttonHeight)
        primaryButton.titleLabel?.font = FontBook.bigText
        
        plainButton.withHeight(Constants.plainButtonHeight)
        plainButton.titleLabel?.font = FontBook.bigText
        plainButton.titleEdgeInsets = UIEdgeInsets(top: Constants.plainTopPadding,
                                              left: .zero,
                                              bottom: Constants.spacing,
                                              right: .zero)
        plainButton.contentEdgeInsets = Constants.buttonEdgeInsets
        plainButton.setStyle(style: .plain)
        
        stack([checkboxStackView, primaryButton, strokeButtonBox, plainButton],
              spacing: Constants.spacing,
              padding: Constants.containerPadding)
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DSCheckboxButtonViewModel) {
        self.viewModel = viewModel
        
        if let buttonVM = viewModel.mainButtonVM {
            primaryButton.configure(viewModel: buttonVM)
        }
        
        strokeButtonBox.isHidden = viewModel.strokeButtonVM == nil
        if let strokeButtonVM = viewModel.strokeButtonVM {
            strokeButtonBox.subview.configure(viewModel: strokeButtonVM)
        }
        
        plainButton.isHidden = viewModel.plainButtonVM == nil
        if let plainButtonVM = viewModel.plainButtonVM {
            plainButton.configure(viewModel: plainButtonVM)
        }
        
        checkboxStackView.safelyRemoveArrangedSubviews()
        viewModel.checkboxVMs.forEach { checkboxVM in
            let checkboxView = CheckmarkView()
            checkboxView.configure(
                text: checkboxVM.text,
                isChecked: checkboxVM.isChecked
            ) { [weak self] isSelected in
                self?.viewModel?.updateState(
                    selectedCheckbox: checkboxVM,
                    isSelected: isSelected)
            }
            checkboxStackView.addArrangedSubview(checkboxView)
        }
    }
    
    public func setupUI(borderColor: UIColor, borderWidth: CGFloat) {
        self.withBorder(width: borderWidth, color: borderColor)
    }
    
    public func isValid() -> Bool {
        guard let viewModel = viewModel else { return false }
        return viewModel.checkboxVMs.allSatisfy({ $0.isChecked })
    }
    
    public func inputCode() -> String {
        return "checkboxBtnOrg"
    }
    
    public func inputData() -> AnyCodable? {
        return nil
    }
}

// MARK: - Constants
extension DSCheckboxButtonView {
    private enum Constants {
        static let cornerRadius: CGFloat = 8
        static let spacing: CGFloat = 16
        static let containerPadding = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let buttonHeight: CGFloat = 48
        static let plainButtonHeight: CGFloat = 56
        static let plainTopPadding: CGFloat = 24
        static let buttonEdgeInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        static let borderWidth: CGFloat = 1
        static let borderColor = UIColor("#C5D9E9")
    }
}
