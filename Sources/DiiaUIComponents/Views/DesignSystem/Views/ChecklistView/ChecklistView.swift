
import UIKit
import DiiaCommonTypes

// MARK: - ViewModel
public class ChecklistViewModel {
    public let id: String?
    public let title: String?
    public let items: [ChecklistItemViewModel]
    public let plainButton: Action?
    public let checklistType: ChecklistType
    public var onClick: (() -> Void)?
    public let componentId: String?
    public let inputCode: String?
    public let mandatory: Bool?
    
    public init(id: String? = nil,
                title: String?,
                items: [ChecklistItemViewModel],
                plainButton: Action? = nil,
                checklistType: ChecklistType,
                componentId: String? = nil,
                inputCode: String? = nil,
                mandatory: Bool? = nil,
                onClick: (() -> Void)? = nil) {
        self.id = id
        self.title = title
        self.items = items
        self.plainButton = plainButton
        self.checklistType = checklistType
        self.onClick = onClick
        self.componentId = componentId
        self.inputCode = inputCode
        self.mandatory = mandatory
    }
    
    public func updateSelectionState(forItem selectedItem: ChecklistItemViewModel) {
        let newSelectionState = !selectedItem.isSelected
        
        if case .single = checklistType, newSelectionState == false {
            selectedItem.isSelected = true
        } else if case .single = checklistType, newSelectionState == true {
            items.forEach { $0.isSelected = ($0 === selectedItem) }
        } else {
            selectedItem.isSelected = newSelectionState
        }
        onClick?()
    }
    
    public func deselectAll(except itemCode: String? = nil) {
        items.forEach {
            if $0.code == itemCode { return }
            $0.isSelected = false
        }
    }
    
    public func selectedItems() -> [ChecklistItemViewModel] {
        return items.filter({ $0.isSelected && $0.isAvailable})
    }
}

/// design_system_code: checkboxRoundGroupOrg, radioBtnGroupOrg
///
public class ChecklistView: BaseCodeView, DSInputComponentProtocol, DSResetStateComponentProtocol {
    private lazy var stackView = UIStackView.create(in: self)
    private var itemViews: [ChecklistItemView] = []
    
    private(set) var viewModel: ChecklistViewModel?
    
    public override func setupSubviews() {
        self.backgroundColor = .white
        self.layer.cornerRadius = Constants.cornerRadius
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: ChecklistViewModel, eventHandler: ((ConstructorItemEvent) -> Void)? = nil) {
        self.viewModel = viewModel
        stackView.safelyRemoveArrangedSubviews()
        itemViews = []
        
        if let titleText = viewModel.title {
            addTitleLabel(text: titleText)
        }
        for (index, itemVM) in viewModel.items.enumerated() {
            appendItemView(with: itemVM)
            if index < viewModel.items.count - 1 {
                addSeparatorView()
            }
        }
        
        if let plainButtonVM = viewModel.plainButton {
            addPlainButton(with: plainButtonVM)
        }
        eventHandler?(.onComponentConfigured(with: .checkmark(viewModel: viewModel)))
        eventHandler?(.onComponentConfigured(with: .resetStateComponent(component: self)))
    }
    
    // MARK: - Private Methods
    private func addTitleLabel(text: String) {
        let titleLabelBox = BoxView(subview: UILabel().withParameters(font: FontBook.usualFont))
        titleLabelBox.subview.text = text
        titleLabelBox.withConstraints(insets: Constants.contentInsets)
        stackView.addArrangedSubview(titleLabelBox)
        addSeparatorView()
    }
    
    private func appendItemView(with itemVM: ChecklistItemViewModel) {
        accessibilityIdentifier = itemVM.componentId
        guard let viewModel = viewModel else { return }
        itemVM.onClick = { [weak viewModel] in
            viewModel?.updateSelectionState(forItem: itemVM)
        }
        
        let itemView = ChecklistItemView()
        itemView.configure(with: itemVM)
        itemView.setupUI(checkboxStyle: viewModel.checklistType.checkboxStyle)
        itemViews.append(itemView)
        stackView.addArrangedSubview(itemView)
    }
    
    private func addPlainButton(with model: Action) {
        let plainButton = ActionButton()
        plainButton.setupUI(font: FontBook.usualFont, secondaryColor: .clear)
        plainButton.withHeight(Constants.buttonHeight)
        plainButton.titleEdgeInsets = Constants.buttonTitleEdgeInsets
        plainButton.action = model
        addSeparatorView()
        stackView.addArrangedSubview(plainButton)
    }
    
    private func addSeparatorView() {
        let separatorBox = BoxView(subview: UIView()).withConstraints(
            insets: .zero,
            size: CGSize(width: 0, height: Constants.separatorHeight)
        )
        separatorBox.subview.backgroundColor = UIColor(AppConstants.Colors.emptyDocuments)
        stackView.addArrangedSubview(separatorBox)
    }
}

//MARK: - DSInputComponentProtocol
extension ChecklistView {
    public func isValid() -> Bool {
        if viewModel?.mandatory == false {
            return true
        } else {
            return !(viewModel?.selectedItems().isEmpty ?? true)
        }
    }
    
    public func inputCode() -> String {
        return viewModel?.inputCode ?? viewModel?.id ?? "radioBtnGroupOrg"
    }
    
    public func inputData() -> AnyCodable? {
        guard let viewModel = viewModel else { return nil }
        switch viewModel.checklistType {
        case .single:
            return viewModel.selectedItems().first?.getInputData()
        case .multiple:
            let codeList: [AnyCodable] = viewModel.selectedItems().compactMap {
                return $0.getInputData()
            }
            return .array(codeList)
        }
    }
    
    public func setOnChangeHandler(_ handler: @escaping () -> Void) {
        viewModel?.onClick = handler
    }
}

//MARK: - DSResetStateComponentProtocol
extension ChecklistView {
    public func clearState() {
        viewModel?.deselectAll()
    }
}

// MARK: - Constants
extension ChecklistView {
    private enum Constants {
        static let cornerRadius: CGFloat = 8
        static let buttonTitleEdgeInsets: UIEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 0)
        static let buttonHeight: CGFloat = 56
        static let contentInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let separatorHeight: CGFloat = 1
    }
}
