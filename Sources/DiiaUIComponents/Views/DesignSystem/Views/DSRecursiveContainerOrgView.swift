import DiiaCommonTypes
import UIKit

public struct DSRecursiveContainerOrgModel: Codable {
    public let componentId: String?
    public let inputCode: String?
    public let mandatory: Bool?
    public let template: AnyCodable
    public let items: [AnyCodable]
    public let maxNumber: Int?
    public let btnWhiteLargeIconAtm: DSBtnPlainIconModel?
    public let btnAddOptionAtm: DSBtnAddOptionAtm?

    public init(componentId: String?, inputCode: String?, mandatory: Bool?, template: AnyCodable, items: [AnyCodable], maxNumber: Int?, btnWhiteLargeIconAtm: DSBtnPlainIconModel?, btnAddOptionAtm: DSBtnAddOptionAtm?) {
        self.componentId = componentId
        self.inputCode = inputCode
        self.mandatory = mandatory
        self.template = template
        self.items = items
        self.maxNumber = maxNumber
        self.btnWhiteLargeIconAtm = btnWhiteLargeIconAtm
        self.btnAddOptionAtm = btnAddOptionAtm
    }
}

/// design_system_code: recursiveContainerOrg
public final class DSRecursiveContainerOrgView: BaseCodeView {
    private let mainStack = UIStackView.create(spacing: Constants.stackSpacing)
    private let itemsStack = UIStackView.create(spacing: Constants.stackSpacing)

    private var addButton: ActionButton?

    private var viewFabric = DSViewFabric.instance
    private var eventHandler: ((ConstructorItemEvent) -> Void)?
    private var model: DSRecursiveContainerOrgModel?
    
    private var templateViewsDict: [UUID: DSTemplateContainerOrgView] = [:]
    private var templateViews: [DSTemplateContainerOrgView] = []

    // MARK: - Lifecycle
    public override func setupSubviews() {
        super.setupSubviews()

        mainStack.addArrangedSubview(itemsStack)

        addSubview(mainStack)
        mainStack.fillSuperview()
    }

    // MARK: - Public
    public func configure(for model: DSRecursiveContainerOrgModel) {
        accessibilityIdentifier = model.componentId
        self.model = model

        if let addButton {
            mainStack.safelyRemoveArrangedSubview(subview: addButton)
            self.addButton = nil
        }

        itemsStack.safelyRemoveArrangedSubviews()
        model.items.forEach { addItem($0) }
        updateItemsStackVisibility()

        if let addButtonModel = model.btnWhiteLargeIconAtm {
            addAddButton(
                label: addButtonModel.label,
                action: .action(addButtonModel.action ?? .init(type: Constants.addAction)),
                iconCode: addButtonModel.icon,
                contentHorizontalAlignment: .center
            )
        } else if let addButtonOptionModel = model.btnAddOptionAtm {
            addAddButton(
                label: addButtonOptionModel.label,
                action: .action(addButtonOptionModel.action ?? .init(type: Constants.addAction)),
                iconCode: addButtonOptionModel.iconLeft?.code,
                contentHorizontalAlignment: .leading
            )
        }
    }

    public func setFabric(_ fabric: DSViewFabric) {
        self.viewFabric = fabric
    }
    
    public func setEventHandler(_ eventHandler: @escaping ((ConstructorItemEvent) -> Void)) {
        self.eventHandler = eventHandler
    }

    // MARK: - Private
    private func setLocalActionIfNeeded(forModel model: DSBtnAddOptionAtm) -> DSBtnAddOptionAtm {
        return DSBtnAddOptionAtm(
            componentId: model.componentId,
            label: model.label,
            description: model.description,
            iconLeft: model.iconLeft,
            state: model.state,
            action: model.action ?? .init(type: Constants.addAction)
        )
    }

    private func addAddButton(
        label: String,
        action: ConstructorItemEvent,
        iconCode: String?,
        contentHorizontalAlignment: UIControl.ContentHorizontalAlignment
    ) {
        let buttonId = UUID()
        let addButton = ActionButton()

        self.addButton = addButton

        mainStack.addArrangedSubview(addButton)
        addButton.withHeight(Constants.buttonHeight)
        addButton.type = .full
        addButton.setupUI(font: FontBook.usualFont, cornerRadius: Constants.cornerRadius, contentHorizontalAlignment: contentHorizontalAlignment)

        // imageEdgeInsets was deprecated and does't work
        if iconCode != nil {
            addButton.titleEdgeInsets = Constants.buttonTitlePaddings
        }
        addButton.contentEdgeInsets = Constants.buttonContentPaddings
        let image = DSImageNameResolver.instance.imageForCode(imageCode: iconCode)
        addButton.action = Action(title: label, image: image) { [weak self] in
            self?.handleEvent(action, id: buttonId)
        }

        updateButtonState()
        updateItemsStackVisibility()
    }

    private func handleEvent(_ event: ConstructorItemEvent, id: UUID) {
        if let actionParameters = event.actionParameters() {
            switch actionParameters.type {
            case Constants.addAction:
                if let template = model?.template {
                    addItem(template)
                }
            case Constants.deleteAction:
                removeItem(id)
            default:
                eventHandler?(event)
            }

            updateItemsStackVisibility()
        } else {
            eventHandler?(event)
        }

        updateButtonState()
    }
    
    private func removeItem(_ id: UUID) {
        if let removingView = templateViewsDict[id] {
            itemsStack.safelyRemoveArrangedSubview(subview: removingView)
            templateViewsDict[id] = nil
            if let arrIndex = templateViews.firstIndex(where: { $0 === removingView }) {
                templateViews.remove(at: arrIndex)
                if isValid()  {
                    UIAccessibility.post(notification: .layoutChanged, argument: addButton)
                }
            }
            eventHandler?(.inputChanged(.init(inputCode: inputCode(), inputData: inputData())))
            updateButtonState()
        }
    }
    
    private func addItem(_ item: AnyCodable) {
        let id = UUID()
        let templateView = DSTemplateContainerOrgView()
        templateView.setFabric(viewFabric)
        templateView.configure(templateModel: item, eventHandler: { [weak self] event in
            self?.handleEvent(event, id: id)
        })
        templateViewsDict[id] = templateView
        templateViews.append(templateView)
        itemsStack.addArrangedSubview(templateView)
        eventHandler?(.inputChanged(.init(inputCode: inputCode(), inputData: inputData())))
        
        UIAccessibility.post(notification: .layoutChanged, argument: templateViews.last)
    }

    private func updateItemsStackVisibility() {
        itemsStack.isHidden = itemsStack.arrangedSubviews.isEmpty
    }

    private func updateButtonState() {
        let lessThanMax = (model?.maxNumber ?? .max) > templateViewsDict.values.count
        let isAddButtonEnabled = lessThanMax && areTemplatesValid()

        addButton?.isEnabled = isAddButtonEnabled
        addButton?.alpha = isAddButtonEnabled ? 1 : 0.3
    }
    
    private func areTemplatesValid() -> Bool {
        return templateViews.allSatisfy { $0.isValid() }
    }
}

extension DSRecursiveContainerOrgView: DSInputComponentProtocol {
    public func inputCode() -> String {
        return model?.inputCode ?? .empty
    }
    
    public func inputData() -> AnyCodable? {
        return .array(templateViews.compactMap { $0.inputData() })
    }
    
    public func isValid() -> Bool {
        if model?.mandatory == true {
            return !templateViews.isEmpty && areTemplatesValid()
        } else {
            return areTemplatesValid()
        }
    }
}

extension DSRecursiveContainerOrgView {
    enum Constants {
        static let buttonHeight: CGFloat = 56
        static let stackSpacing: CGFloat = 16
        static let cornerRadius: CGFloat = 16
        static let buttonTitlePaddings: UIEdgeInsets = .init(left: 16.0)
        static let buttonContentPaddings: UIEdgeInsets = .init(left: 20.0, right: 20.0)
        static let deleteAction = "delete_block_item"
        static let addAction = "add_new_template"
    }
}

public final class DSTemplateContainerOrgView: BaseCodeView {

    private let templateContainer = UIView()
    
    private var viewFabric = DSViewFabric.instance
    
    private var inputViews: [DSInputComponentProtocol] = []
    
    public override func setupSubviews() {
        super.setupSubviews()
        addSubview(templateContainer)
        templateContainer.fillSuperview()
    }
    
    public func configure(templateModel: AnyCodable, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        templateContainer.subviews.forEach { $0.removeFromSuperview() }
        if let view = viewFabric.makeView(from: templateModel, withPadding: .fixed(paddings: .zero), eventHandler: eventHandler) {
            templateContainer.addSubview(view)
            view.fillSuperview()
        }
        inputViews = templateContainer.findTypedSubviews()
    }
    
    public func setFabric(_ fabric: DSViewFabric) {
        self.viewFabric = fabric
    }
    
    public func isValid() -> Bool {
        return inputViews.allSatisfy { $0.isValid() }
    }
    
    public func inputData() -> AnyCodable? {
        var dict: [String: AnyCodable] = [:]
        for view in inputViews {
            dict[view.inputCode()] = view.inputData()
        }
        return .dictionary(dict)
    }
}
