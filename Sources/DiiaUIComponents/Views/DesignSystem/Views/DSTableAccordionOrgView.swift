
import UIKit
import DiiaCommonTypes

/// design_system_code: tableAccordionOrg
public final class DSTableAccordionOrgView: BaseCodeView {
    // MARK: - Properties
    private let mainStack =  UIStackView.create(
        .vertical
    )

    private lazy var headingView = DSTableMainHeadingView()
    private lazy var attentionIconMessageView = DSAttentionIconMessageView()

    private var viewFabric = DSViewFabric.instance

    // MARK: - Lifecycle
    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius

        addSubview(mainStack)
        mainStack.fillSuperview(padding: Constants.mainStackPaddings)
    }

    // MARK: - Private
    private func makeDivider() -> UIView {
        let view = UIView().withHeight(Constants.dividerHeight)
        view.backgroundColor = Constants.dividerColor
        return view
    }

    // MARK: - Public
    public func configure(with model: DSTableAccordionOrgModel, urlOpener: URLOpenerProtocol?, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        mainStack.safelyRemoveArrangedSubviews()

        if let headingModel = model.tableMainHeadingMlc {
            let viewModel = DSTableMainHeadingViewModel(headingModel: headingModel) {
                if let iconAction = headingModel.icon?.action {
                    eventHandler(.action(iconAction))
                }
            }

            headingView.configure(with: viewModel)
            mainStack.addArrangedSubview(headingView)
        }

        for (index, item) in model.items.enumerated() {
            guard let view = viewFabric.makeView(from: item, withPadding: .fixed(paddings: .zero), eventHandler: eventHandler) else {
                continue
            }
            mainStack.addArrangedSubview(view)

            if index != model.items.count - 1 {
                mainStack.addArrangedSubview(makeDivider())
            }
        }

        if let attentionMessageModel = model.attentionIconMessageMlc {
            attentionIconMessageView.configure(with: attentionMessageModel, urlOpener: urlOpener)
            mainStack.addArrangedSubview(attentionIconMessageView)
        }
    }

    public func setFabric(_ viewFabric: DSViewFabric) {
        self.viewFabric = viewFabric
    }
}

// MARK: - DSTableAccordionOrgView+Constants
extension DSTableAccordionOrgView {
    private enum Constants {
        static let cornerRadius = CGFloat(16)
        static let dividerColor = UIColor("#E2ECF4")
        static let dividerHeight = CGFloat(1)
        static let mainStackPaddings = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}
