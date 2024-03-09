import UIKit

// MARK: - ViewModel
public class ChecklistViewModel {
    public let id: String?
    public let title: String?
    public let items: [ChecklistItemViewModel]
    public let checklistType: ChecklistType
    public var onClick: (() -> Void)?
    
    public init(id: String? = nil,
                title: String?,
                items: [ChecklistItemViewModel],
                checklistType: ChecklistType,
                onClick: (() -> Void)? = nil) {
        self.id = id
        self.title = title
        self.items = items
        self.checklistType = checklistType
        self.onClick = onClick
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
    
    public func deselectAll() {
        items.forEach { $0.isSelected = false }
    }
    
    public func selectedItems() -> [ChecklistItemViewModel] {
        return items.filter({ $0.isSelected })
    }
}

/// design_system_code: checkboxRoundGroupOrg, radioBtnGroupOrg
public class ChecklistView: BaseCodeView {
    private lazy var stackView = UIStackView.create(views: [], in: self)
    private var itemViews: [ChecklistItemView] = []
    
    private var viewModel: ChecklistViewModel?
    
    public override func setupSubviews() {
        self.backgroundColor = .white
        self.layer.cornerRadius = Constants.cornerRadius
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: ChecklistViewModel) {
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
        guard let viewModel = viewModel else { return }
        itemVM.onClick = {
            viewModel.updateSelectionState(forItem: itemVM)
        }

        let itemView = ChecklistItemView()
        itemView.configure(with: itemVM)
        itemView.setupUI(checkboxStyle: viewModel.checklistType.checkboxStyle)
        itemViews.append(itemView)
        let itemViewBox = BoxView(subview: itemView).withConstraints(insets: Constants.contentInsets)
        stackView.addArrangedSubview(itemViewBox)
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

// MARK: - Constants
extension ChecklistView {
    private enum Constants {
        static let cornerRadius: CGFloat = 8
        static let contentInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let separatorHeight: CGFloat = 1
    }
}
