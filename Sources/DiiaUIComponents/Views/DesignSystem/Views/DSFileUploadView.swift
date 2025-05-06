
import UIKit
import DiiaCommonTypes

public struct DSFileUploadModel: Codable {
    public let title: String?
    public let description: String?
    public let maxCount: Int?
    public let aspectRatio: FileAspectRatio?
    public let btnPlainIconAtm: DSBtnPlainIconModel
    
    public init(title: String?, description: String?, maxCount: Int?, btnPlainIconAtm: DSBtnPlainIconModel, aspectRatio: FileAspectRatio? = nil) {
        self.title = title
        self.description = description
        self.maxCount = maxCount
        self.btnPlainIconAtm = btnPlainIconAtm
        self.aspectRatio = aspectRatio
    }
}

public enum FileAspectRatio: String, Codable {
    case square
    case threeFour
}

final public class DSFileUploadViewModel: NSObject {
    public let title: String?
    public let descriptionText: String?
    public let maxCount: Int
    public let subitems: Observable<[DSFileUploadItemViewModel]> = .init(value: [])
    public let aspectRatio: FileAspectRatio?
    public var action: Action?
    public var sheetActions: [Action]?
    public var onChange: Callback?
    
    
    public init(title: String?,
                descriptionText: String?,
                maxCount: Int,
                action: Action? = nil,
                sheetActions: [Action]? = nil,
                onChange: Callback? = nil,
                aspectRatio: FileAspectRatio? = nil) {
        self.title = title
        self.descriptionText = descriptionText
        self.maxCount = maxCount
        self.action = action
        self.onChange = onChange
        self.aspectRatio = aspectRatio
        self.sheetActions = sheetActions
        super.init()
    }
    
    public func uploadedFileIds() -> [String] {
        var fileIds: [String] = []
        subitems.value.forEach { item in
            switch item.state.value {
            case .loaded(let id):
                fileIds.append(id)
            default:
                break
            }
        }
        return fileIds
    }
    
    public func isValid() -> Bool {
        let fileIds = uploadedFileIds()
        return fileIds.count == subitems.value.count && fileIds.count > 0
    }
}

/// DS_Code: fileUploadGroupOrg
final public  class DSFileUploadView: BaseCodeView, DSInputComponentProtocol {
    private let mainStack =  UIStackView.create(views: [])
    private let filesStack = UIStackView.create(views: [])
    private let titleStack = UIStackView.create(views: [], spacing: Constants.titleStackConstants).withMargins(Constants.titleStackMargins)
    private let buttonStack = UIStackView.create(views: [])
    private let titleLabel = UILabel().withParameters(font: FontBook.usualFont)
    private let descriptionLabel = UILabel().withParameters(font: FontBook.statusFont, textColor: Constants.detailsTextColor)
    private let addButton = ActionButton()
    private var viewModel: DSFileUploadViewModel?
    
    public override func setupSubviews() {
        self.backgroundColor = .white
        self.layer.cornerRadius = Constants.cornerRadius
        
        addSubview(mainStack)
        mainStack.fillSuperview()
        
        buttonStack.addArrangedSubviews([
            addButton
        ])
        
        titleStack.addArrangedSubviews([
            titleLabel,
            descriptionLabel
        ])
        
        mainStack.addArrangedSubviews([
            titleStack,
            addSeparator(),
            filesStack,
            buttonStack
        ])
        self.layer.cornerRadius = Constants.cornerRadius
        addButton.type = .full
        addButton.setupUI(font: FontBook.usualFont, bordered: false, textColor: .black, secondaryColor: .clear, imageRenderingMode: .alwaysOriginal, contentHorizontalAlignment: .center)
        addButton.withHeight(Constants.buttonHeight)
        addButton.titleEdgeInsets = Constants.buttonTitleEdgeInsets
    }
    
    public func configure(with viewModel: DSFileUploadViewModel) {
        self.viewModel?.subitems.removeObserver(observer: self)
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        titleLabel.isHidden = viewModel.title?.count ?? 0 == 0
        descriptionLabel.text = viewModel.descriptionText
        descriptionLabel.isHidden = viewModel.descriptionText?.count ?? 0 == 0
        addButton.action = viewModel.action
        addButton.isHidden = viewModel.action == nil
        
        viewModel.subitems.observe(observer: self, { [weak self] files in
            self?.updateItems(files: files)
            self?.viewModel?.onChange?()
        })
    }
    
    private func updateItems(files: [DSFileUploadItemViewModel]) {
        filesStack.isHidden = files.isEmpty
        filesStack.safelyRemoveArrangedSubviews()
        
        files.forEach {
            let view = DSFileUploadItemView()
            view.configure(viewModel: $0)
            filesStack.addArrangedSubviews([
                view,
                addSeparator()
            ])
        }
        validateAddButton(files)
    }
    
    private func addSeparator() -> UIView {
        let separatorView = UIView().withHeight(Constants.separatorHeight)
        separatorView.backgroundColor = Constants.separatorColor
        return separatorView
    }
    
    private func validateAddButton(_ files: [DSFileUploadItemViewModel]) {
        let isBelowMax = files.count < viewModel?.maxCount ?? 0
        addButton.isEnabled = isBelowMax
        addButton.alpha = isBelowMax ? 1.0 : Constants.disabledAlpha
    }
    
    public func isValid() -> Bool {
        guard let vm = viewModel else { return false }
        return vm.isValid()
    }
    
    public func inputCode() -> String {
        return Constants.inputCode
    }
    
    public func inputData() -> AnyCodable? {
        guard let vm = viewModel else { return nil }
        return .array(vm.uploadedFileIds().map { .string($0) })
    }
    
    public func setOnChangeHandler(_ handler: @escaping Callback) {
        viewModel?.onChange = handler
    }
}

private extension DSFileUploadView {
    enum Constants {
        static let buttonTitleEdgeInsets: UIEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 0)
        static let titleStackMargins: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let detailsTextColor = UIColor.black.withAlphaComponent(0.5)
        static let titleStackConstants: CGFloat = 4
        static let stackSpacing: CGFloat = 16
        static let cornerRadius: CGFloat = 8
        static let buttonHeight: CGFloat = 56
        static let separatorHeight: CGFloat = 2
        static let separatorColor = UIColor("#E2ECF4")
        static let disabledAlpha = 0.3
        static let inputCode = "fileUpload"
    }
}
