
import UIKit
import DiiaCommonTypes

/// design_system_code: tableBlockOrgV2
public class DSTableBlockOrgV2View: BaseCodeView {
    // MARK: - Properties
    private lazy var mainStack = UIStackView.create(
        views: [
            squareChipStatusViewContainer,
            mainHeadingView,
            tableSecondaryHeadingView,
            itemsStackContainer,
            attentionIconMessageView
        ],
        spacing: Constants.mainStackSpacing
    )

    private let squareChipStatusView = DSChipStatusAtmView()
    private lazy var squareChipStatusViewContainer = UIStackView.create(
        .horizontal,
        views: [squareChipStatusView, UIView()]
    )
    private let mainHeadingView = DSTableMainHeadingView()
    private let tableSecondaryHeadingView = DSTableMainHeadingView()
    private let attentionIconMessageView = DSAttentionIconMessageView()

    private let itemsStackContainer = UIView()
    private let itemsStack = UIStackView.create(spacing: Constants.itemsSpacing)

    private var viewFabric = DSViewFabric.instance

    // MARK: - Lifecycle
    public override func setupSubviews() {
        super.setupSubviews()

        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius

        addSubview(mainStack)
        mainStack.fillSuperview(padding: Constants.contentPaddings)

        itemsStackContainer.addSubview(itemsStack)
        itemsStack.fillSuperview()
    }

    // MARK: - Public Methods
    public func configure(with model: DSTextBlockV2Model, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        accessibilityIdentifier = model.componentId

        squareChipStatusViewContainer.isHidden = model.chipStatusAtm == nil
        if let chipStatusAtm = model.chipStatusAtm {
            squareChipStatusView.configure(for: chipStatusAtm)
        }

        mainHeadingView.isHidden = model.tableMainHeadingMlc == nil
        if let mainHeadingModel = model.tableMainHeadingMlc {
            let vm = DSTableMainHeadingViewModel(
                componentId: mainHeadingModel.componentId,
                label: mainHeadingModel.label,
                description: mainHeadingModel.description
            )
            mainHeadingView.configure(with: vm)
        }

        tableSecondaryHeadingView.isHidden = model.tableSecondaryHeadingMlc == nil
        if let secondaryHeadingModel = model.tableSecondaryHeadingMlc {
            let vm = DSTableMainHeadingViewModel(
                componentId: secondaryHeadingModel.componentId,
                label: secondaryHeadingModel.label,
                description: secondaryHeadingModel.description
            )
            tableSecondaryHeadingView.configure(with: vm)
        }

        itemsStack.safelyRemoveArrangedSubviews()
        itemsStackContainer.isHidden = model.items.isEmpty
        if !model.items.isEmpty {
            var subviews: [UIView] = []
            let views = model.items.compactMap {
                viewFabric.makeView(
                    from: $0,
                    withPadding: .fixed(paddings: .zero),
                    eventHandler: eventHandler)
            }

            for (index, view) in views.enumerated() {
                subviews.append(view)
                if index < views.count - 1 {
                    subviews.append(addSeparator())
                }
            }

            itemsStack.addArrangedSubviews(subviews)
        }

        attentionIconMessageView.isHidden = model.attentionIconMessageMlc == nil
        if let attentionIconMessageModel = model.attentionIconMessageMlc {
            attentionIconMessageView.configure(with: attentionIconMessageModel)
        }
    }

    private func addSeparator() -> UIView {
        let separatorView = UIView()
        separatorView.backgroundColor = Constants.separatorColor
        separatorView.withHeight(1)
        return separatorView
    }
    
    public func setFabric(_ fabric: DSViewFabric) {
        self.viewFabric = fabric
    }
}

// MARK: - DSTableBlockOrgV2View+Constants
private extension DSTableBlockOrgV2View {
    enum Constants {
        static let cornerRadius: CGFloat = 16
        static let itemsSpacing: CGFloat = 8
        static let contentPaddings = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let mainStackSpacing: CGFloat = 16
        static let separatorColor: UIColor = .init("#E2ECF4")
        static let separatorHeight: CGFloat = 1
    }
}
