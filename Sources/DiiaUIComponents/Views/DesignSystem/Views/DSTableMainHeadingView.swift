
import UIKit
import DiiaCommonTypes

public class DSTableMainHeadingViewModel {
    public let componentId: String?
    public let label: String
    public let description: String?
    
    public init(componentId: String?, label: String, description: String?) {
        self.componentId = componentId
        self.label = label
        self.description = description
    }
}

/// design_system_code: tableMainHeadingMlc
public class DSTableMainHeadingView: BaseCodeView {
    
    // MARK: - Subviews
    private let containerStackView = UIStackView.create(views: [], spacing: Constants.spacing)
    private let titleLabel = UILabel().withParameters(font: FontBook.smallHeadingFont)
    private let descriptionLabel = UILabel().withParameters(font: FontBook.usualFont, textColor: Constants.valueTextColor)
    
    // MARK: - Properties
    private var viewModel: DSTableMainHeadingViewModel?
    
    // MARK: - Init
    public override func setupSubviews() {
        addSubview(containerStackView)
        containerStackView.fillSuperview()
        
        containerStackView.addArrangedSubviews([titleLabel, descriptionLabel])
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DSTableMainHeadingViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.label
        
        descriptionLabel.isHidden = viewModel.description == nil
        if let description = viewModel.description {
            descriptionLabel.text = description
        }
    }
}

// MARK: - Constants
private extension DSTableMainHeadingView {
    enum Constants {
        static let valueTextColor: UIColor = .black.withAlphaComponent(0.4)
        static let spacing: CGFloat = 8
    }
}
