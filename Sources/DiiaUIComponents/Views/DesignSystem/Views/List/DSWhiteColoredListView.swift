import UIKit

public struct DSListViewModel {
    public let title: String?
    public let items: [DSListItemViewModel]
    
    public init(title: String? = nil,
                items: [DSListItemViewModel]) {
        self.title = title
        self.items = items
    }
}

/// design_system_code: listItemGroupOrg
public class DSWhiteColoredListView: BaseCodeView {
    private lazy var stackView = UIStackView.create(views: [])
    
    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.layer.cornerRadius = Constants.cornerRadius
        addSubview(stackView)
        stackView.fillSuperview()
    }
    
    // MARK: - Public Methods
    public func configure(viewModel: DSListViewModel) {
        stackView.safelyRemoveArrangedSubviews()
        if let title = viewModel.title {
            addTitleView(title)
            addSeparator()
        }
        for (index, item) in viewModel.items.enumerated() {
            addListItemView(with: item)
            if index < viewModel.items.count - 1 {
                addSeparator()
            }
        }
    }
    
    // MARK: - Private Methods
    private func addListItemView(with viewModel: DSListItemViewModel) {
        let itemView = DSListItemView()
        itemView.configure(viewModel: viewModel)
        stackView.addArrangedSubview(itemView)
    }
    
    private func addTitleView(_ title: String) {
        let descriptionLabel = BoxView(subview: UILabel().withParameters(font: FontBook.usualFont))
        descriptionLabel.subview.text = title
        descriptionLabel.withConstraints(insets: Constants.titleInsets)
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    private func addSeparator() {
        let separator = UIView().withHeight(Constants.separatorHeight)
        separator.backgroundColor = UIColor(AppConstants.Colors.emptyDocuments)
        stackView.addArrangedSubview(separator)
    }
}

// MARK: - Constants
extension DSWhiteColoredListView {
    private enum Constants {
        static let cornerRadius: CGFloat = 16
        static let titleInsets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let separatorHeight: CGFloat = 1
    }
}
