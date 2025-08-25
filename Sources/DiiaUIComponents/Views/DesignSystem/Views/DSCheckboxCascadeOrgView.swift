
/// design_system_code: checkboxCascadeOrg
///

import UIKit
import DiiaCommonTypes

public struct DSCheckboxCascadeOrg: Codable {
    public let componentId: String?
    public let inputCode: String?
    public let mandatory: Bool?
    public let tableItemCheckboxMlc: DSTableItemCheckboxModel?
    public let items: [DSTableItemCheckboxMlc]
    public let isEnabled: Bool?
    public let minMandatorySelectedItems: Int?
}

public class DSCheckboxCascadeViewModel {
    public let componentId: String
    public let inputCode: String
    public let mandatory: Bool?
    public let tableItemCheckboxMlc: DSTableItemCheckboxItemViewModel?
    public let items: Observable<[DSTableItemCheckboxItemViewModel]>
    public let isEnabled: Bool?
    public var onChange: Callback?
    public let minMandatorySelectedItems: Int
    
    public init(
        componentId: String,
        inputCode: String?,
        mandatory: Bool?,
        tableItemCheckboxMlc: DSTableItemCheckboxModel?,
        items: [DSTableItemCheckboxModel],
        isEnabled: Bool?,
        minMandatorySelectedItems: Int?
    ) {
        self.componentId = componentId
        self.inputCode = inputCode ?? componentId
        self.mandatory = mandatory
        if let titleCheckbox = tableItemCheckboxMlc {
            self.tableItemCheckboxMlc = DSTableItemCheckboxItemViewModel(model: titleCheckbox)
        } else {
            self.tableItemCheckboxMlc = nil
        }
        self.isEnabled = isEnabled
        self.items = Observable(value: items.map { DSTableItemCheckboxItemViewModel(model: $0) })
        self.minMandatorySelectedItems = minMandatorySelectedItems ?? 1
        
        checkupHeaderState()
    }
    
    public func inputData() -> AnyCodable? {
        let selectedList: [AnyCodable] = items.value
            .filter { $0.isSelected.value }
            .compactMap { $0.dataJson ?? $0.inputCode }
            .map { AnyCodable.string($0) }
        return selectedList.isEmpty ? nil : .array(selectedList)
    }
    
    fileprivate func headerCheckboxClicked() {
        items.value.forEach { $0.isSelected.value = tableItemCheckboxMlc?.isSelected.value == true }
        onChange?()
    }
    
    fileprivate func childCheckboxClicked() {
        checkupHeaderState()
        onChange?()
    }
    
    private func checkupHeaderState() {
        let selectedCount = items.value.filter { $0.isSelected.value == true }.count
        if selectedCount == items.value.count {
            tableItemCheckboxMlc?.isSelected.value = true
            tableItemCheckboxMlc?.isPartialSelected.value = false
        } else if selectedCount == 0 {
            tableItemCheckboxMlc?.isSelected.value = false
            tableItemCheckboxMlc?.isPartialSelected.value = false
        } else {
            tableItemCheckboxMlc?.isPartialSelected.value = true
        }
    }
}

public struct DSTableItemCheckboxMlc: Codable {
    let tableItemCheckboxMlc: DSTableItemCheckboxModel?
}

final public class DSCheckboxCascadeOrgView: BaseCodeView {
    
    private var mainStackView = UIStackView.create(.vertical, spacing: Constants.spacing)
    private var tableItemCheckboxView = DSTableItemCheckboxView()
    private var cascadeContainer = BoxView(subview: UIStackView.create(spacing: Constants.spacing))
    
    private var viewModel: DSCheckboxCascadeViewModel?
    
    public override func setupSubviews() {
        addSubview(mainStackView)
        mainStackView.fillSuperview()
        mainStackView.addArrangedSubview(tableItemCheckboxView)
        mainStackView.addArrangedSubview(cascadeContainer)
        cascadeContainer.withConstraints(insets: .init(top: .zero,
                                                       left: Constants.padding,
                                                       bottom: .zero,
                                                       right: .zero))
    }
    
    public func configure(with viewModel: DSCheckboxCascadeViewModel,
                          eventHandler: ((ConstructorItemEvent) -> Void)? = nil) {
        
        eventHandler?(.onComponentConfigured(with: .cascadeView(viewModel: viewModel)))
        
        accessibilityIdentifier = viewModel.componentId
        
        self.viewModel?.items.removeObserver(observer: self)
        viewModel.items.observe(observer: self) { [weak self, weak viewModel] items in
            guard let self, let viewModel else { return }
            
            items.forEach {
                $0.onClick = { [weak viewModel] in
                    viewModel?.childCheckboxClicked()
                }
            }
            viewModel.tableItemCheckboxMlc?.onClick = { [weak viewModel] in
                viewModel?.headerCheckboxClicked()
            }
            
            self.cascadeContainer.subview.safelyRemoveArrangedSubviews()
            self.cascadeContainer.withConstraints(insets: .init(
                top: .zero,
                left: viewModel.tableItemCheckboxMlc == nil ? .zero : Constants.padding,
                bottom: .zero,
                right: .zero))
            
            self.tableItemCheckboxView.isHidden = viewModel.tableItemCheckboxMlc == nil
            self.cascadeContainer.isHidden = items.isEmpty
            for item in items {
                let view = DSTableItemCheckboxView()
                view.configure(with: item)
                self.cascadeContainer.subview.addArrangedSubview(view)
            }
            if let tableItemVM = viewModel.tableItemCheckboxMlc {
                self.tableItemCheckboxView.configure(with: tableItemVM)
            }
            
            viewModel.childCheckboxClicked()
        }
        
        self.viewModel = viewModel
    }
}

extension DSCheckboxCascadeOrgView: DSInputComponentProtocol {
    public func isValid() -> Bool {
        if !(viewModel?.mandatory == true) { return true }
        var selectionCounter = 0
        let items = viewModel?.items.value ?? []
        for item in items {
            if item.mandatory == true && item.isSelected.value == false {
                return false
            }
            if item.isSelected.value == true {
                selectionCounter += 1
            }
        }
        return selectionCounter >= viewModel?.minMandatorySelectedItems ?? 1
    }
    
    public func inputCode() -> String {
        return viewModel?.inputCode ?? .empty
    }
    
    public func inputData() -> AnyCodable? {
        return viewModel?.inputData()
    }
}

private extension DSCheckboxCascadeOrgView {
    enum Constants {
        static let tableItemCheckboxMlc = "tableItemCheckboxMlc"
        static let spacing: CGFloat = 16
        static let padding: CGFloat = 24
    }
}
