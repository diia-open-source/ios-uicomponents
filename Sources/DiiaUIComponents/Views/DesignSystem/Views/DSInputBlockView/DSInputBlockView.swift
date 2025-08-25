
import UIKit
import Lottie
import DiiaCommonTypes

/// design_system_code: inputBlockOrg
public class DSInputBlockView: BaseCodeView {
    
    // MARK: - Subviews
    private let mainStack =  UIStackView.create(spacing: Constants.mainStackSpacing)
    private let itemsStack = UIStackView.create(spacing: Constants.itemsSpacing)
    private lazy var tableMainHeadingView = DSTableMainHeadingView()
    private lazy var tableSecondaryHeadingView = DSTableMainHeadingView()
    private lazy var attentionIconMessageView = DSAttentionIconMessageView()
    
    // MARK: - Properties
    private var viewFabric = DSViewFabric.instance
    private var viewModel: DSInputBlockViewModel?
    
    // MARK: - Init
    public override func setupSubviews() {
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius

        addSubview(mainStack)
        mainStack.fillSuperview(padding: Constants.contentPaddings)
    }
    
    // MARK: - Public Methods
    public func setFabric(_ viewFabric: DSViewFabric) {
        self.viewFabric = viewFabric
    }
    
    public func configure(with viewModel: DSInputBlockViewModel) {
        self.viewModel = viewModel
        accessibilityIdentifier = viewModel.componentId
        mainStack.safelyRemoveArrangedSubviews()
        itemsStack.safelyRemoveArrangedSubviews()
        
        if let tableMainHeadingVM = viewModel.tableMainHeadingViewModel {
            tableMainHeadingView.configure(with: tableMainHeadingVM)
            mainStack.addArrangedSubview(tableMainHeadingView)
        }
        
        if let tableSecondaryHeadingVM = viewModel.tableSecondaryHeadingViewModel {
            tableSecondaryHeadingView.configure(with: tableSecondaryHeadingVM)
            mainStack.addArrangedSubview(tableSecondaryHeadingView)
        }
        
        if !viewModel.items.isEmpty {
            mainStack.addArrangedSubview(itemsStack)
        }
        viewModel.items.forEach {
            guard let view = viewFabric.makeView(
                from: $0,
                withPadding: .fixed(paddings: .zero),
                eventHandler: viewModel.eventHandler
            ) else { return }
            itemsStack.addArrangedSubview(view)
        }

        if let attentionIconMessageModel = viewModel.attentionIconMessageModel {
            attentionIconMessageView.configure(
                with: attentionIconMessageModel,
                urlOpener: viewModel.urlOpener
            )
            mainStack.addArrangedSubview(attentionIconMessageView)
        }
    }
}

// MARK: - Constants
private extension DSInputBlockView {
    enum Constants {
        static let cornerRadius: CGFloat = 16
        static let contentPaddings = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let mainStackSpacing: CGFloat = 16
        static let itemsSpacing: CGFloat = 8
    }
}
