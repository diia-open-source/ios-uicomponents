
import UIKit

/// design_system_code: btnLoadIconPlainGroupMlc
public final class BorderedActionsView: BaseCodeView {
    private lazy var contentStackView = UIStackView.create(spacing: Constants.stackSpacing, in: self, padding: Constants.stackPadding)
    private var viewModels = [IconedLoadingStateViewModel]()
    
    public override func setupSubviews() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = Constants.cornerRadius
        self.withBorder(width: Constants.borderWidth, color: Constants.borderColor)
    }
    
    // MARK: - Public methods
    public func configureView(with actions: [IconedLoadingStateViewModel]) {
        viewModels = actions
        contentStackView.safelyRemoveArrangedSubviews()
        viewModels.forEach {
            let iconedLoadingView = IconedLoadingStateView()
            iconedLoadingView.configure(viewModel: $0)
            contentStackView.addArrangedSubview(iconedLoadingView)
        }
    }
    
    public func setupUI(stackSpacing: CGFloat? = nil, alignment: UIStackView.Alignment = .fill) {
        if let stackSpacing {
            contentStackView.spacing = stackSpacing
        }
        contentStackView.alignment = alignment
    }
}

extension BorderedActionsView {
    private enum Constants {
        static let stackPadding = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let stackSpacing: CGFloat = 16
        static let cornerRadius: CGFloat = 16
        static let borderWidth: CGFloat = 1
        static let borderColor = UIColor(AppConstants.Colors.emptyDocumentsBackground)
    }
}
