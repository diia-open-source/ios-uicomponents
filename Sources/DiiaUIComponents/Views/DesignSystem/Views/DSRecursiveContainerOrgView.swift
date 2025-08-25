import DiiaCommonTypes
import UIKit

public struct DSRecursiveContainerOrgModel: Codable {
    public let componentId: String?
    public let inputCode: String?
    public let mandatory: Bool?
    public let template: AnyCodable
    public let items: [AnyCodable]
    public let maxNumber: Int?
    public let btnWhiteLargeIconAtm: DSBtnPlainIconModel
    
    public init(componentId: String?, inputCode: String?, mandatory: Bool?, template: AnyCodable, items: [AnyCodable], maxNumber: Int?, btnWhiteLargeIconAtm: DSBtnPlainIconModel) {
        self.componentId = componentId
        self.inputCode = inputCode
        self.mandatory = mandatory
        self.template = template
        self.items = items
        self.maxNumber = maxNumber
        self.btnWhiteLargeIconAtm = btnWhiteLargeIconAtm
    }
}

/// design_system_code: recursiveContainerOrg
public class DSRecursiveContainerOrgView: BaseCodeView {

    private let itemsStack = UIStackView.create(spacing: Constants.stackSpacing)
    private let addButton = ActionButton()

    private var viewFabric = DSViewFabric.instance
    private var eventHandler: ((ConstructorItemEvent) -> Void)?
    private var model: DSRecursiveContainerOrgModel?
    
    private var templateViewsDict: [UUID: DSTemplateContainerOrgView] = [:]
    private var templateViews: [DSTemplateContainerOrgView] = []

    public override func setupSubviews() {
        super.setupSubviews()
        
        addSubview(itemsStack)
        addSubview(addButton)
        itemsStack.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        addButton.anchor(top: itemsStack.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: Constants.stackSpacing, left: .zero, bottom: .zero, right: .zero))
        addButton.type = .full
        addButton.setupUI(font: FontBook.usualFont, cornerRadius: Constants.cornerRadius)
        addButton.withHeight(Constants.buttonHeight)
        addButton.titleEdgeInsets = Constants.buttonTitlePaddings
    }
    
    public func configure(for model: DSRecursiveContainerOrgModel) {
        accessibilityIdentifier = model.componentId
        self.model = model
        itemsStack.safelyRemoveArrangedSubviews()
        
        model.items.forEach { addItem($0) }
        let buttonId = UUID()
        addButton.action = Action(
            title: model.btnWhiteLargeIconAtm.label,
            iconName: UIComponentsConfiguration.shared.imageProvider?.imageNameForCode(imageCode: model.btnWhiteLargeIconAtm.icon)
        ) { [weak self] in
            self?.handleEvent(.action(model.btnWhiteLargeIconAtm.action ?? .init(type: Constants.addAction)), id: buttonId)
        }
        updateButtonState()
    }
    
    public func setFabric(_ fabric: DSViewFabric) {
        self.viewFabric = fabric
    }
    
    public func setEventHandler(_ eventHandler: @escaping ((ConstructorItemEvent) -> Void)) {
        self.eventHandler = eventHandler
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
            return
        }
        eventHandler?(event)
        if case .inputChanged = event {
            updateButtonState()
        }
    }
    
    private func removeItem(_ id: UUID) {
        if let removingView = templateViewsDict[id] {
            itemsStack.safelyRemoveArrangedSubview(subview: removingView)
            templateViewsDict[id] = nil
            if let arrIndex = templateViews.firstIndex(where: { $0 === removingView }) {
                templateViews.remove(at: arrIndex)
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
    }
    
    private func updateButtonState() {
        let isValidAdd = (model?.maxNumber ?? .max) > templateViewsDict.values.count && isValidTemplate()
        
        addButton.isEnabled = isValidAdd
        addButton.alpha = isValidAdd ? 1 : 0.3
    }
    
    fileprivate func isValidTemplate() -> Bool {
        return model?.mandatory == false || templateViews.allSatisfy { $0.isValid() }
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
        updateButtonState()
        return isValidTemplate()
    }
}

extension DSRecursiveContainerOrgView {
    enum Constants {
        static let buttonHeight: CGFloat = 56
        static let stackSpacing: CGFloat = 16
        static let cornerRadius: CGFloat = 16
        static let buttonTitlePaddings: UIEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 0)
        static let deleteAction = "delete_block_item"
        static let addAction = "add_new_template"
    }
}

public class DSTemplateContainerOrgView: BaseCodeView {

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
