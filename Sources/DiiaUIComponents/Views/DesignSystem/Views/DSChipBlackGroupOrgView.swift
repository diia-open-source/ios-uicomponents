
import UIKit
import DiiaCommonTypes

public struct DSChipBlackGroupModel: Codable {
    public let componentId: String?
    public let id: String?
    public let inputCode: String?
    public let mandatory: Bool?
    public let label: String?
    public let minCount: Int?
    public let maxCount: Int?
    public let items: [DSChipBlackMlcItemModel]
    public let preselectedCodes: [String]?
}

public final class DSChipBlackGroupViewModel {
    public let componentId: String?
    public let id: String?
    public let inputCode: String?
    public let mandatory: Bool?
    public let label: String?
    public let minCount: Int?
    public let maxCount: Int?
    public let items: [DSChipBlackMlcViewModel]
    public var onClick: ((ConstructorItemEvent?) -> Void)?

    public init(componentId: String?,
                id: String?,
                inputCode: String?,
                mandatory: Bool?,
                label: String?,
                minCount: Int?,
                maxCount: Int?,
                items: [DSChipBlackMlcViewModel],
                onClick: ((ConstructorItemEvent?) -> Void)? = nil) {
        self.componentId = componentId
        self.id = id
        self.inputCode = inputCode
        self.mandatory = mandatory
        self.label = label
        self.minCount = minCount
        self.maxCount = maxCount
        self.items = items
        self.onClick = onClick
    }
    
    public func updateState(for chip: DSChipBlackMlcViewModel, action: ConstructorItemEvent?) {
        let currentlySelectedCount = selectedItems().count
        if chip.state.value == .selected {
            chip.state.value = .unselected
            onClick?(action)
            updateAllChipsState()
            return
        }
        if let maxCount = maxCount, currentlySelectedCount >= maxCount {
            chip.state.value = .disabled
        } else {
            chip.state.value = .selected
            onClick?(action)
        }
        updateAllChipsState()
    }
    
    private func updateAllChipsState() {
        let currentlySelectedCount = selectedItems().count
        
        for chip in items {
            if let maxCount = maxCount, currentlySelectedCount >= maxCount, chip.state.value != .selected {
                chip.state.value = .disabled
            } else if chip.state.value == .disabled {
                chip.state.value = .unselected
            }
        }
    }
    
    public func selectedItems() -> [DSChipBlackMlcViewModel] {
        return items.filter { $0.state.value == .selected }
    }
    
    public func deselectAll() {
        items.forEach({$0.state.value = .unselected})
    }
}

///DS code chipBlackGroupOrg
public final class DSChipBlackGroupOrgView: BaseCodeView, DSResetStateComponentProtocol {
    private let mainStack = UIStackView.create(.vertical)
    private let separatorView = UIView()
    private let chipTitleLabelContainer = UIView()
    private let chipsTitleLabel = UILabel().withParameters(font: FontBook.usualFont, textColor: .black)
    private let chipItemsVStack = UIStackView.create(.vertical, spacing: 8, alignment: .leading, distribution: .equalSpacing).withMargins(Constants.insets)
    private var chipsViewModel: DSChipBlackGroupViewModel?
    
    public override func setupSubviews() {
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
        chipTitleLabelContainer.backgroundColor = .clear
        separatorView.withHeight(Constants.separatorHeight)
        separatorView.backgroundColor = Constants.separatorColor
        addSubview(mainStack)
        chipTitleLabelContainer.addSubview(chipsTitleLabel)
        chipsTitleLabel.fillSuperview(padding: Constants.insets)
        mainStack.fillSuperview()
        mainStack.addArrangedSubviews([
            chipTitleLabelContainer,
            separatorView,
            chipItemsVStack
        ])
        setupAccessibility()
        layoutIfNeeded()
    }
    
    public func configure(with viewModel: DSChipBlackGroupViewModel, eventHandler: ((ConstructorItemEvent) -> Void)? = nil) {
        chipsViewModel = viewModel
        chipsTitleLabel.text = viewModel.label
        setNeedsLayout()
        
        eventHandler?(.onComponentConfigured(with: .resetStateComponent(component: self)))
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard let viewModel = chipsViewModel, viewModel.items.count > 0 else { return }
        chipItemsVStack.safelyRemoveArrangedSubviews()
        
        var index = 0
        var currentVms: [DSChipBlackMlcViewModel] = []
        var currentWidth: CGFloat = 0
        let availableWidth = mainStack.frame.width - 2 * Constants.sideInset
        
        while index < viewModel.items.count {
            let chip = viewModel.items[index]
            let width = DSChipBlackMlcView.widthForText(text: chip.label)
            let additionalSpacing: CGFloat = currentVms.count > 0 ? Constants.chipHorizontalInset : 0
            let totalWidth = currentWidth + width
            
            if totalWidth <= availableWidth {
                currentWidth += width + additionalSpacing
                currentVms.append(viewModel.items[index])
            } else {
                chipItemsVStack.addArrangedSubview(createChipsHstack(chips: currentVms))
                currentWidth = width
                currentVms = [chip]
            }
            index += 1
        }
        chipItemsVStack.addArrangedSubview(createChipsHstack(chips: currentVms))
    }
    
    private func createChipsHstack(chips: [DSChipBlackMlcViewModel]) -> UIStackView {
        let stack = UIStackView.create(
            .horizontal,
            views: chips.map { viewModel in
                let view = DSChipBlackMlcView()
                viewModel.onClick = { [weak self] action in
                    self?.chipsViewModel?.updateState(for: viewModel, action: action)
                }

                view.configure(with: viewModel)
                return view
            },
            spacing: Constants.chipHorizontalInset)
        stack.withHeight(Constants.chipHeight)
        return stack
    }
    
    private func setupAccessibility() {
        chipsTitleLabel.isAccessibilityElement = true
        chipsTitleLabel.accessibilityTraits = .header
    }
}

extension DSChipBlackGroupOrgView {
    public func clearState() {
        chipsViewModel?.deselectAll()
    }
}

extension DSChipBlackGroupOrgView: DSInputComponentProtocol {
    public func isValid() -> Bool {
        let isMandatory = chipsViewModel?.mandatory ?? false
        let selectedItemsCount = chipsViewModel?.selectedItems().count ?? 0
        let minCount = chipsViewModel?.minCount ?? 0
        
        if isMandatory {
            return selectedItemsCount >= minCount
        }
        
        return true
    }
    
    public func inputCode() -> String {
        return chipsViewModel?.inputCode ?? "chipBlackGroupOrg"
    }
    
    public func inputData() -> AnyCodable? {
        let selectedItems = chipsViewModel?.selectedItems() ?? []
        return .array(selectedItems.compactMap {
            .string($0.code)
        })
    }
}

extension DSChipBlackGroupOrgView {
    private enum Constants {
        static let chipHorizontalInset: CGFloat = 8
        static let chipHeight: CGFloat = 38
        static let sideInset: CGFloat = 16
        static let separatorColor: UIColor = .init("#E2ECF4")
        static let insets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let cornerRadius: CGFloat = 16
        static let separatorHeight: CGFloat = 1
    }
}
