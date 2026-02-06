
import UIKit
import DiiaCommonTypes

public final class DSListViewModel: NSObject{
    public let componentId: String?
    public let title: String?
    public let buttonModel: DSBtnPlainIconModel?
    public let eventHandler: ((ConstructorItemEvent) -> ())?
    public let items: Observable<[DSListItemViewModel]>
    public var isInteractionsEnabled = Observable<Bool>(value: true)

    public init(componentId: String? = nil,
                title: String? = nil,
                items: [DSListItemViewModel] = [],
                buttonModel: DSBtnPlainIconModel? = nil,
                eventHandler: ((ConstructorItemEvent) -> ())? = nil) {
        self.componentId = componentId
        self.title = title
        self.items = Observable.init(value: items)
        self.buttonModel = buttonModel
        self.eventHandler = eventHandler
    }
}

/// design_system_code: listItemGroupOrg
public final class DSWhiteColoredListView: BaseCodeView {
    private lazy var stackView = UIStackView.create()
    private var viewModel: DSListViewModel?

    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.layer.cornerRadius = Constants.cornerRadius
        addSubview(stackView)
        stackView.fillSuperview()
    }
    
    // MARK: - Public Methods
    public func configure(viewModel: DSListViewModel, eventHandler: ((ConstructorItemEvent) -> Void)? = nil) {
        eventHandler?(.onComponentConfigured(with: .listItems(viewModel: viewModel)))
        self.accessibilityIdentifier = viewModel.componentId
        
        self.viewModel?.isInteractionsEnabled.removeObserver(observer: self)
        viewModel.isInteractionsEnabled.observe(observer: self) { [weak self] isInteractionsEnabled in
            self?.isUserInteractionEnabled = isInteractionsEnabled
        }
        self.viewModel?.items.removeObserver(observer: self)
        viewModel.items.observe(observer: self) { [weak self, weak viewModel] items in
            guard let self, let viewModel else { return }
            self.stackView.safelyRemoveArrangedSubviews()
            if let title = viewModel.title {
                self.addTitleView(title)
                self.addSeparator()
            }
            for (index, item) in items.enumerated() {
                self.addListItemView(with: item)
                if index < items.count - 1 || (index == items.count - 1 && viewModel.buttonModel != nil) {
                    self.addSeparator()
                }
            }
            if let buttonModel = viewModel.buttonModel {
                self.addButtonPlain(for: buttonModel)
            }
        }
        
        self.viewModel = viewModel
    }
    
    public func setupSubitems(alignment: UIStackView.Alignment = .center,
                              titleLines: Int = 0,
                              detailLines: Int = 0) {
        for case let listView as DSListItemView in stackView.subviews {
            listView.configureUI(titleLines: titleLines,
                                 detailsLines: detailLines,
                                 stackAlign: alignment)
        }
    }
    
    // MARK: - Private Methods
    private func addListItemView(with viewModel: DSListItemViewModel) {
        let itemView = DSListItemView()
        itemView.configure(viewModel: viewModel)
        stackView.addArrangedSubview(itemView)
    }

    private func addButtonPlain(for buttonPlainIcon: DSBtnPlainIconModel) {
        if let actionParameters = buttonPlainIcon.action {
            let action = Action(
                title: buttonPlainIcon.label,
                iconName: UIComponentsConfiguration.shared.imageProvider.imageNameForCode(imageCode: buttonPlainIcon.icon)
            ) { [weak self] in
                self?.viewModel?.eventHandler?(.action(actionParameters))
            }
            let addButton = ActionButton(action: action, type: .full)
            addButton.setupUI(font: FontBook.usualFont, textColor: .black)
            addButton.titleEdgeInsets = Constants.buttonEdgeInset
            let boxView = BoxView(subview: addButton).withConstraints(centeredX: true)
            boxView.withHeight(Constants.buttonHeight)
            stackView.addArrangedSubview(boxView)
        }
    }
    
    private func addTitleView(_ title: String) {
        let descriptionLabel = BoxView(subview: UILabel().withParameters(font: FontBook.usualFont))
        descriptionLabel.subview.text = title
        descriptionLabel.subview.accessibilityTraits = .header
        descriptionLabel.withConstraints(insets: Constants.titleInsets)
        descriptionLabel.subview.setContentCompressionResistancePriority(.required, for: .vertical)
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    private func addSeparator() {
        let separator = UIView().withHeight(Constants.separatorHeight)
        separator.backgroundColor = UIColor(AppConstants.Colors.emptyDocuments)
        let boxView = BoxView(subview: separator).withConstraints(insets: Constants.separatorInsets)
        stackView.addArrangedSubview(boxView)
    }
}

// MARK: - Constants
extension DSWhiteColoredListView {
    private enum Constants {
        static let buttonEdgeInset = UIEdgeInsets(top: .zero, left: 8, bottom: .zero, right: -8)
        static let buttonHeight: CGFloat = 56
        static let cornerRadius: CGFloat = 16
        static let titleInsets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let separatorInsets: UIEdgeInsets = .init(top: .zero, left: 16, bottom: .zero, right: 16)
        static let separatorHeight: CGFloat = 1
    }
}
