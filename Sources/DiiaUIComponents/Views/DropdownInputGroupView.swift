
import UIKit

public final class DropdownInputGroupViewModel {
    let dropdownListViewModel: DropdownListViewModel
    let inputDocumentViewModel: InputDocumentViewModel
    var eventHandler: ((ConstructorItemEvent) -> Void)?
    
    init(dropdownListViewModel: DropdownListViewModel, inputDocumentViewModel: InputDocumentViewModel) {
        self.dropdownListViewModel = dropdownListViewModel
        self.inputDocumentViewModel = inputDocumentViewModel
    }
}

/// dropdownInputGroupOrg
public struct DropdownInputGroupOrg: Codable {
    public let componentId: String
    public let dropdownListMlc: DropdownListMlc
    public let inputDocumentMlc: InputDocumentMlc
    
    public init(componentId: String, dropdownListMlc: DropdownListMlc, inputDocumentMlc: InputDocumentMlc) {
        self.componentId = componentId
        self.dropdownListMlc = dropdownListMlc
        self.inputDocumentMlc = inputDocumentMlc
    }
}

/// dropdownInputGroupOrg
public final class DropdownInputGroupView: BaseCodeView {
    private let dropdownListView = DropdownListView()
    private let inputDocumentView = InputDocumentView()
    
    public override func setupSubviews() {
        let dashView = UIView()
        dashView.backgroundColor = .black
        
        addSubviews([dropdownListView, dashView, inputDocumentView])
        
        dropdownListView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor)
        dashView.anchor(
            leading: dropdownListView.trailingAnchor,
            trailing: inputDocumentView.leadingAnchor,
            padding: .init(horizontal: Constants.padding),
            size: Constants.dashSize)
        
        dashView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        inputDocumentView.anchor(
            top: topAnchor,
            trailing: trailingAnchor,
            size: Constants.inputSize
        )
        
        setupAccessibility()
    }
    
    public func configure(viewModel: DropdownInputGroupViewModel) {
        dropdownListView.configure(viewModel: viewModel.dropdownListViewModel)
        inputDocumentView.configure(viewModel: viewModel.inputDocumentViewModel)
    }
    
    private func setupAccessibility() {
        isAccessibilityElement = false
        accessibilityElements = [dropdownListView, inputDocumentView]
    }
}

private extension DropdownInputGroupView {
    enum Constants {
        static let dashSize = CGSize(width: 6, height: 2)
        static let padding = CGFloat(4)
        static let inputSize = CGSize(width: 66, height: 48)
    }
}
