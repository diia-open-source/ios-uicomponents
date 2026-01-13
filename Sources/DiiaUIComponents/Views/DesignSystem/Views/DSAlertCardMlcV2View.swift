
import UIKit

public final class DSAlertCardMlcV2View: BaseCodeView {
    // MARK: - Properties
    private let icon = UIImageView().withSize(Constants.iconSize)
    private let topLabel = UILabel().withParameters(font: FontBook.smallHeadingFont)
    private let secondaryLabel = UILabel().withParameters(font: FontBook.usualFont)
    private let button = DSPrimaryDefaultButton()

    private lazy var stack = UIStackView.create(
        views: [icon, topLabel, secondaryLabel, button],
        spacing: Constants.stackSpacing,
        alignment: .center
    )

    // MARK: - Lifecycle
    override public func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
        topLabel.textAlignment = .center
        secondaryLabel.textAlignment = .center
        button.contentEdgeInsets = Constants.buttonInsets

        addSubview(stack)
        stack.fillSuperview(padding: Constants.stackPadding)
    }

    // MARK: - Public
    public func configure(model: DSAlertCardMlcV2Model, eventHandler: ((ConstructorItemEvent) -> Void)?) {
        icon.isHidden = model.iconAtm == nil
        icon.image = UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: model.iconAtm?.code)

        topLabel.text = model.label

        secondaryLabel.isHidden = model.text == nil
        secondaryLabel.text = model.text

        button.isHidden = model.btnPrimaryAdditionalAtm == nil
        if let buttonModel = model.btnPrimaryAdditionalAtm {
            let buttonViewModel = DSLoadingButtonViewModel(
                title: buttonModel.label,
                state: .enabled
            )
            button.configure(viewModel: buttonViewModel)

            buttonViewModel.callback = { [weak buttonViewModel] in
                guard let action = buttonModel.action, let buttonViewModel else { return }
                eventHandler?(.buttonAction(parameters: action, viewModel: buttonViewModel))
            }
        }

        if model.text != nil {
            stack.setCustomSpacing(Constants.labelsSpacing, after: topLabel)
        }
    }
}

// MARK: - DSAlertCardMlcV2View+Constants
private extension DSAlertCardMlcV2View {
    enum Constants {
        static let cornerRadius: CGFloat = 16.0
        static let stackSpacing: CGFloat = 16.0
        static let labelsSpacing: CGFloat = 8.0
        static let iconSize = CGSize(width: 32.0, height: 32.0)
        static let stackPadding = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        static let buttonInsets = UIEdgeInsets(top: 10.0, left: 32.0, bottom: 10.0, right: 32.0)
    }
}
