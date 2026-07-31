
import UIKit

public final class DropdownWithInputsViewModel {
    public let firstLabel: String?
    public let secondLabel: String?
    public let dropdownListViewModel: DropdownInputGroupViewModel
    public let inputDocViewModel: InputDocumentViewModel
    
    public init(firstLabel: String?, secondLabel: String?, dropdownListViewModel: DropdownInputGroupViewModel, inputDocViewModel: InputDocumentViewModel) {
        self.firstLabel = firstLabel
        self.secondLabel = secondLabel
        self.dropdownListViewModel = dropdownListViewModel
        self.inputDocViewModel = inputDocViewModel
    }
}

/// dropdownWithInputsOrg
public struct DropdownWithInputsOrg: Codable {
    public let componentId: String
    public let firstLabel: String?
    public let secondLabel: String?
    public let dropdownInputGroupOrg: DropdownInputGroupOrg
    public let inputDocumentMlc: InputDocumentMlc
    
    public init(componentId: String, firstLabel: String?, secondLabel: String?, dropdownInputGroupOrg: DropdownInputGroupOrg, inputDocumentMlc: InputDocumentMlc) {
        self.componentId = componentId
        self.firstLabel = firstLabel
        self.secondLabel = secondLabel
        self.dropdownInputGroupOrg = dropdownInputGroupOrg
        self.inputDocumentMlc = inputDocumentMlc
    }
}

/// dropdownWithInputsOrg
public final class DropdownWithInputsView: BaseCodeView {
    private let firstLabel = UILabel().withParameters(font: FontBook.statusFont)
    private let secondaryLabel = UILabel().withParameters(font: FontBook.statusFont)
    private let dropdownList = DropdownInputGroupView()
    private let inputDocumentField = InputDocumentView()
    
    public override func setupSubviews() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = Constants.cornerRadius
        
        addSubview(backgroundView)
        backgroundView.fillSuperview()
        
        let leftStack = UIStackView.create(views: [firstLabel, dropdownList], spacing: Constants.spacing)
        let rightStack = UIStackView.create(views: [secondaryLabel, inputDocumentField], spacing:  Constants.spacing)
        let mainStack = UIStackView.create(
            .horizontal,
            views: [leftStack, rightStack],
            spacing:  Constants.spacing)
        backgroundView.addSubview(mainStack)
        
        mainStack.fillSuperview(padding: .allSides(Constants.padding))
    }
    
    public func configure(viewModel: DropdownWithInputsViewModel) {
        firstLabel.text = viewModel.firstLabel
        firstLabel.isHidden = viewModel.firstLabel == nil
        secondaryLabel.text = viewModel.secondLabel
        secondaryLabel.isHidden = viewModel.secondLabel == nil
        
        dropdownList.configure(viewModel: viewModel.dropdownListViewModel)
        inputDocumentField.configure(viewModel: viewModel.inputDocViewModel)
    }
    
    
}

private extension DropdownWithInputsView {
    enum Constants {
        static let padding = CGFloat(16)
        static let spacing = CGFloat(4)
        static let cornerRadius = CGFloat(16)
    }
}
