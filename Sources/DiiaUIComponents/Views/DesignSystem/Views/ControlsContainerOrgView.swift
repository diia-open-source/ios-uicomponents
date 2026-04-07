
import UIKit
import DiiaCommonTypes

/// design_system_code: controlsContainerOrg
public struct ControlsContainerOrgModel: Codable {
    public let componentId: String
    public let inputCode: String
    public let mandatory: Bool?
    public let minMandatorySelectedItems: Int?
    public let maxMandatorySelectedItems: Int?
    public let controlType: ControlType
    public let items: [ControlsItemOrgModel]
    public let btnPrimaryAdditionalAtm: DSButtonModel?
    
    public init(componentId: String, inputCode: String, mandatory: Bool?, minMandatorySelectedItems: Int?, maxMandatorySelectedItems: Int?, controlType: ControlType, items: [ControlsItemOrgModel], btnPrimaryAdditionalAtm: DSButtonModel?) {
        self.componentId = componentId
        self.inputCode = inputCode
        self.mandatory = mandatory
        self.minMandatorySelectedItems = minMandatorySelectedItems
        self.maxMandatorySelectedItems = maxMandatorySelectedItems
        self.controlType = controlType
        self.items = items
        self.btnPrimaryAdditionalAtm = btnPrimaryAdditionalAtm
    }
    
    public enum ControlType: String, Codable {
        case singleChoice, multipleChoice
    }
}

public final class ControlsContainerOrgViewModel {
    public let model: ControlsContainerOrgModel
    private(set) var items: [ControlsItemOrgViewModel] = []
    private(set) var selectedItems: Set<ControlsItemOrgViewModel> = []
    private(set) var eventHandler: ((ConstructorItemEvent) -> Void)
    
    public init(model: ControlsContainerOrgModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.model = model
        self.eventHandler = eventHandler

        let mapped: [ControlsItemOrgViewModel] = model.items.map { item in
            let vm = ControlsItemOrgViewModel(model: item)
            vm.onChangeSelection = { [weak self, weak vm] _ in
                guard let vm else { return }
                self?.updateSelected(vm)
            }
            return vm
        }
        self.items = mapped
        self.selectedItems = Set(mapped.filter { $0.model.isSelected == true })
    }
    
    private func updateSelected(_ item: ControlsItemOrgViewModel) {
        switch model.controlType {
        case .singleChoice:
            if item.state.value == .selected || item.model.isEnabled == false { return }
            item.state.value = .selected
            selectedItems.forEach {
                $0.state.value = $0.model.isEnabled != false ? .enabled : .disabled
                selectedItems.remove($0)
            }
            selectedItems.insert(item)
        case .multipleChoice:
            if item.model.isEnabled == false { return }
            switch item.state.value {
            case .disabled, .selectedDisabled:
                break
            case .enabled:
                item.state.value = .selected
                selectedItems.insert(item)
            case .selected:
                item.state.value = .enabled
                selectedItems.remove(item)
            }
        }
        eventHandler(.inputChanged(.init(inputCode: model.inputCode, inputData: .array(selectedItems.map { AnyCodable.string($0.model.code) }))))
    }
    
    func isValid() -> Bool {
        if model.mandatory != true && model.maxMandatorySelectedItems == nil && model.minMandatorySelectedItems == nil {
            return true
        }
        switch model.controlType {
        case .singleChoice:
            return selectedItems.count == 1
        case .multipleChoice:
            if let maxMandatorySelectedItems = model.maxMandatorySelectedItems, selectedItems.count > maxMandatorySelectedItems {
                return false
            }
            if let minMandatorySelectedItems = model.minMandatorySelectedItems, selectedItems.count < minMandatorySelectedItems {
                return false
            }
            return true
        }
    }
}

public final class ControlsContainerOrgView: BaseCodeView {
    private lazy var mainStack = UIStackView.create(views: [itemsStack, buttonBox], spacing: Constants.mainStackSpacing)
    private lazy var buttonBox: BoxView<DSPrimaryDefaultButton> = BoxView(subview: DSPrimaryDefaultButton()).withConstraints(insets: .zero, centeredX: true)
    private lazy var itemsStack = UIStackView.create()
    
    private var viewModel: ControlsContainerOrgViewModel?
    private var viewFabric: DSViewFabric = .instance
    
    public override func setupSubviews() {
        addSubview(mainStack)
        mainStack.fillSuperview()
        buttonBox.subview.contentEdgeInsets = Constants.buttonInsets
    }
    
    public func configure(_ viewModel: ControlsContainerOrgViewModel) {
        self.viewModel = viewModel
        
        itemsStack.safelyRemoveArrangedSubviews()
        for item in viewModel.items {
            let view = ControlsItemOrgView()
            view.setupFabric(viewFabric)
            view.configure(item, eventHandler: viewModel.eventHandler)
            let box = BoxView(subview: view).withConstraints(
                insets: UIEdgeInsets(top: item.model.paddingMode.top?.verticalSize ?? Constants.defaultInteritemSpacing)
            )
            itemsStack.addArrangedSubview(box)
        }
        
        buttonBox.isHidden = viewModel.model.btnPrimaryAdditionalAtm == nil
        if let buttonModel = viewModel.model.btnPrimaryAdditionalAtm {
            let buttonViewModel = DSLoadingButtonViewModel(
                title: buttonModel.label,
                state: .enabled,
                componentId: buttonModel.componentId
            )
            buttonBox.subview.configure(viewModel: buttonViewModel)
            buttonBox.subview.accessibilityLabel = buttonModel.label

            buttonViewModel.callback = { [weak buttonViewModel, weak self] in
                guard let action = buttonModel.action, let buttonViewModel, let self else { return }
                self.viewModel?.eventHandler(.buttonAction(parameters: action, viewModel: buttonViewModel))
            }
        }
        
    }
    
    public func setupFabric(_ viewFabric: DSViewFabric) {
        self.viewFabric = viewFabric
    }
}

extension ControlsContainerOrgView: DSInputComponentProtocol {
    public func isValid() -> Bool {
        return viewModel?.isValid() ?? false
    }
    
    public func inputCode() -> String {
        return viewModel?.model.inputCode ?? "controlsContainerOrg"
    }
    
    public func inputData() -> AnyCodable? {
        return .array(viewModel?.selectedItems.map { AnyCodable.string($0.model.code) } ?? [])
    }
}

private extension ControlsContainerOrgView {
    private enum Constants {
        static let buttonInsets = UIEdgeInsets(top: 10.0, left: 32.0, bottom: 10.0, right: 32.0)
        static let defaultInteritemSpacing: CGFloat = 8
        static let mainStackSpacing: CGFloat = 16
    }
}
