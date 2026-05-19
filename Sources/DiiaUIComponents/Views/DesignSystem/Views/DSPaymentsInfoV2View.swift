
import UIKit
import DiiaCommonTypes

/// design_system_code: paymentInfoOrgV2
public final class DSPaymentsInfoV2View: BaseCodeView {
    private let titleLabel = UILabel().withParameters(
        font: FontBook.smallHeadingFont,
        textColor: Constants.titleTextColor)

    private let bottomDescriptionLabel = UILabel().withParameters(
        font: FontBook.usualFont,
        textColor: Constants.bottomDescriptionTextColor,
        textAlignment: .right)

    private let subtitleLabel = UILabel().withParameters(font: FontBook.usualFont)
    private let chipView = DSChipView()
    private let itemsStack = UIStackView.create(spacing: Constants.defaultStackSpacing)
    private let separator = DSDividerLineView()
    private let totalView = DSTableItemHorizontalView()

    private lazy var titleWithChipStack = UIStackView.create(
        .horizontal,
        views: [titleLabel, chipView],
        spacing: Constants.defaultStackSpacing,
        alignment: .top,
        distribution: .fill)

    private lazy var topStack = UIStackView.create(
        views: [titleWithChipStack, subtitleLabel],
        spacing: Constants.topStackSpacing)

    private let btnIconPlainStroke = DSBtnIconPlainStrokeMlcView()
    private let btnPrimaryAdditional = DSPrimaryDefaultButton()

    private lazy var btnPrimaryAdditionalBox = BoxView(subview: btnPrimaryAdditional).withConstraints(centeredX: true)

    private lazy var mainStack = UIStackView.create(
        views: [topStack, itemsStack, separator, totalView, btnIconPlainStroke, btnPrimaryAdditionalBox],
        spacing: Constants.mainStackSpacing)

    private lazy var mainStackBox = BoxView(subview: mainStack).withConstraints(insets: Constants.mainStackInset)

    private lazy var contentStack = UIStackView.create(
        views: [mainStackBox, bottomDescriptionLabel],
        spacing: Constants.defaultStackSpacing)

    private var viewFabric = DSViewFabric.instance

    public override func setupSubviews() {
        mainStack.setCustomSpacing(Constants.largeStackSpacing, after: topStack)
        mainStackBox.backgroundColor = Constants.mainStackBgColor
        mainStackBox.layer.cornerRadius = Constants.cornerRadius

        totalView.setupUI(titleFont: FontBook.bigText, valueFont: FontBook.bigText)
        totalView.setValueAlignment(.right)

        separator.setupUI(height: 1, color: Constants.separatorColor)

        btnPrimaryAdditional.contentEdgeInsets = Constants.additionalButtonInsets
        btnPrimaryAdditional.titleLabel?.font = FontBook.usualFont
        btnPrimaryAdditional.withHeight(Constants.buttonHeight)

        addSubview(contentStack)
        contentStack.fillSuperview()
    }
    
    public func configure(for model: DSPaymentInfoOrgV2Model, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        setupTopStack(model: model)
        setupItemsStack(model: model, eventHandler: eventHandler)
        setupTotalView(model: model)
        setupButtons(model: model, eventHandler: eventHandler)
        setupDescriptionLabel(model: model)
        setupSeparator(model: model)
    }

    public func setFabric(_ viewFabric: DSViewFabric) {
        self.viewFabric = viewFabric
    }

    // MARK: - Private
    private func setupTopStack(model: DSPaymentInfoOrgV2Model) {
        chipView.isHidden = model.titleWithChip?.chipStatusAtm == nil
        subtitleLabel.isHidden = model.titleWithChip?.description ?? model.subtitle == nil

        if let titleWithChipModel = model.titleWithChip {
            titleLabel.text = titleWithChipModel.text

            if let chipModel = titleWithChipModel.chipStatusAtm {
                chipView.configure(for: chipModel)
            }

            topStack.spacing = .zero
            topStack.alignment = .fill

            subtitleLabel.text = titleWithChipModel.description
            subtitleLabel.textColor = Constants.descriptionTextColor
        } else {
            titleLabel.text = model.title
            topStack.alignment = .center
            topStack.spacing = Constants.topStackSpacing

            subtitleLabel.text = model.subtitle
            subtitleLabel.textColor = Constants.subtitleTextColor
        }
    }

    private func setupItemsStack(model: DSPaymentInfoOrgV2Model, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        itemsStack.safelyRemoveArrangedSubviews()
        itemsStack.isHidden = model.items.isEmpty
        for item in model.items {
            if let view = viewFabric.makeView(from: item,
                                              withPadding: .fixed(paddings: .zero),
                                              eventHandler: eventHandler) {
                itemsStack.addArrangedSubview(view)
                if let view = view as? BoxView<DSTableItemHorizontalView> {
                    view.subview.setValueAlignment(.right)
                }
            }
        }
    }

    private func setupTotalView(model: DSPaymentInfoOrgV2Model) {
        totalView.isHidden = model.tableItemHorizontalLargeMlc == nil
        if let total = model.tableItemHorizontalLargeMlc {
            totalView.configure(item: total, urlOpener: UIComponentsConfiguration.shared.urlOpener)
            totalView.setValueAlignment(.right)
        }
    }

    private func setupButtons(model: DSPaymentInfoOrgV2Model, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        btnIconPlainStroke.isHidden = model.btnIconPlainStrokeMlc == nil
        if let strokeButtonModel = model.btnIconPlainStrokeMlc {
            btnIconPlainStroke.accessibilityLabel = strokeButtonModel.label
            btnIconPlainStroke.configure(with: strokeButtonModel, eventHandler: eventHandler)

            if model.btnPrimaryAdditionalAtm != nil {
                mainStack.setCustomSpacing(Constants.largeStackSpacing, after: btnIconPlainStroke)
            }
        }

        btnPrimaryAdditionalBox.isHidden = model.btnPrimaryAdditionalAtm == nil
        if let primaryButtonModel = model.btnPrimaryAdditionalAtm {
            let primaryButtonViewModel = DSLoadingButtonViewModel(
                title: primaryButtonModel.label,
                state: primaryButtonModel.state == .enabled ? .enabled : .disabled,
                componentId: primaryButtonModel.componentId
            )
            btnPrimaryAdditional.configure(viewModel: primaryButtonViewModel)
            btnPrimaryAdditional.accessibilityLabel = primaryButtonModel.label

            primaryButtonViewModel.callback = { [weak primaryButtonViewModel] in
                guard let action = primaryButtonModel.action,
                      let primaryButtonViewModel else { return }
                eventHandler(.buttonAction(parameters: action, viewModel: primaryButtonViewModel))
            }
        }
    }

    private func setupDescriptionLabel(model: DSPaymentInfoOrgV2Model) {
        bottomDescriptionLabel.isHidden = model.description == nil
        bottomDescriptionLabel.text = model.description
    }

    private func setupSeparator(model: DSPaymentInfoOrgV2Model) {
        let isSeparatorLastVisibleItem = mainStack.arrangedSubviews.filter { !$0.isHidden }.last == separator
        separator.isHidden = isSeparatorLastVisibleItem
    }
}

// MARK: - DSPaymentsInfoV2View+Constants
private extension DSPaymentsInfoV2View {
    enum Constants {
        static let topStackSpacing: CGFloat = 4
        static let defaultStackSpacing: CGFloat = 8
        static let mainStackSpacing: CGFloat = 16
        static let largeStackSpacing: CGFloat = 24
        static let cornerRadius: CGFloat = 16
        static let buttonHeight: CGFloat = 36
        static let additionalButtonInsets = UIEdgeInsets(horizontal: 16)
        static let mainStackInset = UIEdgeInsets.allSides(16)
        static let separatorColor = UIColor("#E2ECF4")
        static let titleTextColor: UIColor = .black
        static let mainStackBgColor: UIColor = .white
        static let subtitleTextColor: UIColor = .gray
        static let descriptionTextColor: UIColor = .black
        static let bottomDescriptionTextColor: UIColor = .gray
    }
}
