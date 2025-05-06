
import UIKit
import DiiaCommonTypes

public class DSSmallCheckIconOrgViewModel {
    public let componentId: String?
    public let inputCode: String?
    public let id: String?
    public let title: String?
    public var items: [DSSmallCheckIconMlcViewModel]
    public var onClick: Callback?
    
    public init(componentId: String?, id: String?, title: String?, inputCode: String?, items: [DSSmallCheckIconMlcViewModel]) {
        self.componentId = componentId
        self.id = id
        self.title = title
        self.items = items
        self.inputCode = inputCode
    }
    
    public func updateSelection(from viewModel: DSSmallCheckIconMlcViewModel) {
        resetSelection()
        viewModel.isSelected.value = true
        onClick?()
    }
    
    public func resetSelection() {
        items.forEach { $0.isSelected.value = false }
    }
    
    public func selectedCode() -> String? {
        return items.first { $0.isSelected.value }?.code
    }
}

//ds code: smallCheckIconOrg
public class DSSmallCheckIconOrgView: BaseCodeView {
    private let mainStack = UIStackView.create()
    private let iconsVStack = UIStackView.create(spacing: Constants.spacing, alignment: .leading, distribution: .equalSpacing).withMargins(Constants.paddings)
    private let titleLabelContainer = UIView()
    private let titleLabel = UILabel().withParameters(font: FontBook.usualFont, textColor: .black)
    private let separatorView = DSSeparatorView()
    private var checkIconsViewModel: DSSmallCheckIconOrgViewModel?
    private var selectedIconModel: DSSmallCheckIconMlcViewModel?
    private var eventHandler: ((ConstructorItemEvent) -> Void) = { _ in }
    
    public override func setupSubviews() {
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
        addSubview(mainStack)
        mainStack.fillSuperview()
        titleLabelContainer.addSubview(titleLabel)
        titleLabel.fillSuperview(padding: Constants.paddings)
        mainStack.addArrangedSubviews([titleLabelContainer, separatorView, iconsVStack])
    }
    
    public func configure(with viewModel: DSSmallCheckIconOrgViewModel) {
        self.checkIconsViewModel = viewModel
        titleLabel.text = viewModel.title
        accessibilityIdentifier = viewModel.componentId
        setNeedsLayout()
    }
    
    public func set(eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.eventHandler = eventHandler
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard let viewModel = checkIconsViewModel, viewModel.items.count > 0 else { return }
        iconsVStack.safelyRemoveArrangedSubviews()

        let elementWidth: CGFloat = Constants.iconSize.width
        let elementSpacing: CGFloat = Constants.horizontalInset
        let availableWidth = mainStack.frame.width - 2 * Constants.horizontalInset

        var currentVms: [DSSmallCheckIconMlcViewModel] = []
        var currentWidth: CGFloat = 0

        for checkIcon in viewModel.items {
            let additionalSpacing: CGFloat = currentVms.isEmpty ? 0 : elementSpacing
            let totalWidth = currentWidth + elementWidth + additionalSpacing

            if totalWidth <= availableWidth {
                currentVms.append(checkIcon)
                currentWidth += elementWidth + additionalSpacing
            } else {
                iconsVStack.addArrangedSubview(createIconsHstack(items: currentVms))
                currentVms = [checkIcon]
                currentWidth = elementWidth
            }
        }

        if !currentVms.isEmpty {
            iconsVStack.addArrangedSubview(createIconsHstack(items: currentVms))
        }
    }
    
    private func createIconsHstack(items: [DSSmallCheckIconMlcViewModel]) -> UIStackView {
        let horizontalStack = UIStackView.create(.horizontal, spacing: Constants.horizontalInset)
        let views = items.map { viewModel in
            let view = DSSmallCheckIconMlcView()
            viewModel.onChange = { [weak self] isSelected in
                guard isSelected, self?.selectedIconModel != viewModel else { return }
                self?.checkIconsViewModel?.updateSelection(from: viewModel)
            }
            view.configure(with: viewModel)
            view.withWidth(Constants.iconSize.width)
            return view
        }
        horizontalStack.addArrangedSubviews(views)
        horizontalStack.withHeight(Constants.iconSize.height)
        return horizontalStack
    }
}

extension DSSmallCheckIconOrgView: DSInputComponentProtocol {
    public func isValid() -> Bool {
        guard let items = checkIconsViewModel?.items else {
            return false
        }
        return !items.isEmpty
    }
    
    public func inputCode() -> String {
        return checkIconsViewModel?.inputCode ?? "smallCheckIconOrg"
    }
    
    public func inputData() -> AnyCodable? {
        guard let selectedItem = checkIconsViewModel?.selectedCode() else { return nil}
        return .string(selectedItem)
    }
}

private extension DSSmallCheckIconOrgView {
    enum Constants {
        static let iconSize = CGSize(width: 44, height: 44)
        static let horizontalInset: CGFloat = 16
        static let spacing: CGFloat = 16
        static let paddings = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let separatorColor: UIColor = .init("#E2ECF4")
        static let cornerRadius: CGFloat = 8
    }
}
