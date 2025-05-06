
import UIKit
import DiiaCommonTypes

public struct DSListEditGroupModel: Codable {
    public let componentId: String?
    public let title: String?
    public let inputCode: String
    public let description: String?
    public let items: [LabelValueModel]
    public let btnPlainIconAtm: DSBtnPlainIconModel?
    
    public init(
        componentId: String?,
        inputCode: String,
        title: String?,
        description: String?,
        items: [LabelValueModel],
        btnPlainIconAtm: DSBtnPlainIconModel?
    ) {
        self.componentId = componentId
        self.inputCode = inputCode
        self.title = title
        self.description = description
        self.items = items
        self.btnPlainIconAtm = btnPlainIconAtm
    }
}

public class DSListEditGroupViewModel {
    public let componentId: String?
    public let inputCode: String
    public let title: String?
    public let description: String?
    public var items: Observable<[LabelValueModel]>
    public let buttonAction: DSBtnPlainIconModel?
    public let eventHandler: (ConstructorItemEvent) -> Void
    
    public init(
        componentId: String?,
        inputCode: String,
        title: String?,
        description: String?,
        items: [LabelValueModel],
        buttonAction: DSBtnPlainIconModel?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) {
        self.componentId = componentId
        self.inputCode = inputCode
        self.title = title
        self.description = description
        self.items = .init(value: items)
        self.eventHandler = eventHandler
        self.buttonAction = buttonAction
    }
    
    public func removeItem(with id: String) {
        items.value.removeAll(where: { $0.value == id })
    }
    
    public func addItem(_ item: LabelValueModel) {
        items.value.append(item)
    }
}

/// design_system_code: listItemEditGroupOrg
public class DSListEditGroupView: BaseCodeView, DSInputComponentProtocol {
    
    // MARK: - Subviews
    private let contentStack = UIStackView.create()
    private let headerContainerView = UIView()
    private let titleLabel = UILabel().withParameters(font: FontBook.usualFont)
    private let descriptionLabel = UILabel().withParameters(font: FontBook.statusFont, textColor: .halfBlack)
    private let itemsStack = UIStackView.create()
    private let addButton = ActionButton()
    
    private var itemsViewModels: [DSListItemViewModel] = []
    
    // MARK: - Properties
    private var viewModel: DSListEditGroupViewModel?
    
    // MARK: - Init
    public override func setupSubviews() {
        UIStackView.create(
            views: [titleLabel, descriptionLabel],
            spacing: Constants.headerSpacing,
            in: headerContainerView,
            padding: Constants.headerPaddings)
        
        addSubview(contentStack)
        contentStack.fillSuperview()
        contentStack.addArrangedSubviews([
            headerContainerView,
            itemsStack,
            divider(),
            addButton
        ])
        
        initialSetup()
    }
    
    private func initialSetup() {
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
        
        addButton.type = .full
        addButton.setupUI(font: FontBook.usualFont)
        addButton.withHeight(Constants.buttonHeight)
        addButton.titleEdgeInsets = Constants.buttonTitlePaddings
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DSListEditGroupViewModel) {
        self.viewModel = viewModel
        
        titleLabel.isHidden = viewModel.title == nil
        titleLabel.text = viewModel.title
        descriptionLabel.isHidden = viewModel.description == nil
        descriptionLabel.text = viewModel.description
        headerContainerView.isHidden = viewModel.title == nil && viewModel.description == nil
        viewModel.items.observe(observer: self) { [weak self] items in
            self?.updateItems(items)
        }
        if let buttonPlainIcon = viewModel.buttonAction, let actionParameters = buttonPlainIcon.action {
            addButton.action = Action(
                title: buttonPlainIcon.label,
                iconName: UIComponentsConfiguration.shared.imageProvider?.imageNameForCode(imageCode: buttonPlainIcon.icon)
            ) { [weak self] in
                self?.viewModel?.eventHandler(.action(actionParameters))
            }
        }
    }
    
    // MARK: - Private Methods
    private func updateItemsViews() {
        itemsStack.safelyRemoveArrangedSubviews()
        itemsViewModels.forEach { item in
            let view = DSListItemView()
            view.configure(viewModel: item)
            itemsStack.addArrangedSubviews([divider(), view])
        }
    }
    
    private func updateItems(_ items: [LabelValueModel]) {
        itemsViewModels = items.map { item in
            return DSListItemViewModel(
                id: item.value,
                title: item.label,
                onClick: { [weak self] in
                    guard let self = self, let vm = self.viewModel else { return }
                    vm.removeItem(with: item.value)
                    self.viewModel?.eventHandler(
                        .inputChanged(
                            .init(
                                inputCode: vm.inputCode,
                                inputData: .array(vm.items.value.map { .fromEncodable(encodable: $0) })
                            )))
                })
        }
        updateItemsViews()
    }
    
    private func divider() -> UIView {
        let dividerView = DSDividerLineView()
        dividerView.setupUI(color: .blackSqueeze)
        return dividerView
    }
    
    // MARK: - DSInputComponentProtocol
    public func isValid() -> Bool {
        return true
    }
    
    public func inputCode() -> String {
        return viewModel?.inputCode ?? Constants.inputCode
    }
    
    public func inputData() -> AnyCodable? {
        guard let viewModel = viewModel else { return nil }
        return .array(viewModel.items.value.map { .string($0.value) })
    }
}

// MARK: - Constants
private extension DSListEditGroupView {
    enum Constants {
        static let buttonTitlePaddings: UIEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 0)
        static let headerPaddings: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        
        static let cornerRadius: CGFloat = 8
        static let buttonHeight: CGFloat = 56
        static let headerSpacing: CGFloat = 4
        
        static let inputCode = "editGroupItems"
    }
}
