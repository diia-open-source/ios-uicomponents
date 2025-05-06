
import UIKit
import DiiaCommonTypes

/// design_system_code: checkboxCascadeGroupOrg
struct DSCheckboxCascadeGroupOrg: Codable {
    public let componentId: String?
    public let inputCode: String?
    public let mandatory: Bool?
    public let items: [DSCheckboxCascadeOrgContainer]
    public let minMandatorySelectedItems: Int?
    
    public init(componentId: String?, inputCode: String?, mandatory: Bool?, items: [DSCheckboxCascadeOrgContainer], minMandatorySelectedItems: Int?) {
        self.componentId = componentId
        self.inputCode = inputCode
        self.mandatory = mandatory
        self.items = items
        self.minMandatorySelectedItems = minMandatorySelectedItems
    }
}

struct DSCheckboxCascadeOrgContainer: Codable {
    public let checkboxCascadeOrg: DSCheckboxCascadeOrg
}

public class DSCheckboxCascadeGroupOrgViewModel {
    public let componentId: String
    public let inputCode: String
    public let mandatory: Bool
    public let minMandatorySelectedItems: Int
    public var items: [DSCheckboxCascadeViewModel]
    public var onChange: Callback?
    
    public init(componentId: String, inputCode: String, mandatory: Bool, items: [DSCheckboxCascadeViewModel] = [], minMandatorySelectedItems: Int?) {
        self.componentId = componentId
        self.inputCode = inputCode
        self.mandatory = mandatory
        self.items = items
        self.minMandatorySelectedItems = minMandatorySelectedItems ?? 1
    }
    
    public func inputData() -> AnyCodable? {
        var mappedData: [AnyCodable] = []
        for item in items {
            if let data = item.inputData() {
                mappedData.append(.dictionary([
                    Constants.inputKeyCode: .string(item.inputCode),
                    Constants.inputValueCode: data
                ]))
            }
        }
        if mappedData.isEmpty { return nil }
        return .array(mappedData)
    }
    
    public func isValid() -> Bool {
        if !mandatory { return true }
        var selectedCounter = 0
        for item in items {
            if item.mandatory == true && item.inputData() == nil {
                return false
            }
            if item.inputData() != nil { selectedCounter += 1 }
        }
        return selectedCounter >= minMandatorySelectedItems
    }
}

class DSCheckboxCascadeGroupView: BaseCodeView {
    private let stackView = UIStackView.create(spacing: Constants.spacing)
    private var viewModel: DSCheckboxCascadeGroupOrgViewModel?
    
    override func setupSubviews() {
        addSubview(stackView)
        stackView.fillSuperview()
    }
    
    public func configure(viewModel: DSCheckboxCascadeGroupOrgViewModel) {
        self.accessibilityIdentifier = viewModel.componentId
        self.viewModel = viewModel
        
        stackView.safelyRemoveArrangedSubviews()
        viewModel.items.forEach { item in
            let view = DSCheckboxCascadeOrgView()
            view.configure(with: item)
            stackView.addArrangedSubview(view)
        }
    }
}

extension DSCheckboxCascadeGroupView: DSInputComponentProtocol {
    func isValid() -> Bool {
        return viewModel?.isValid() ?? true
    }
    
    func inputCode() -> String {
        return viewModel?.inputCode ?? .empty
    }
    
    func inputData() -> AnyCodable? {
        return viewModel?.inputData()
    }
}

private extension DSCheckboxCascadeGroupView {
    enum Constants {
        static let spacing: CGFloat = 16
    }
}

private extension DSCheckboxCascadeGroupOrgViewModel {
    enum Constants {
        static let inputKeyCode = "inputCode"
        static let inputValueCode = "values"
    }
}
