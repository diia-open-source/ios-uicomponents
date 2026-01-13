
import UIKit
import DiiaCommonTypes
import Lottie

/// design_system_code: linkSharingOrg
public final class DSLinkSharingOrgView: BaseCodeView {
    // MARK: - Properties
    private let textLabel = UILabel().withParameters(
        font: FontBook.mainFont.regular.size(12),
        numberOfLines: Constants.textNumberOfLines,
        textAlignment: .center,
        lineBreakMode: .byTruncatingTail
    )

    private let descriptionLabel = UILabel().withParameters(
        font: FontBook.statusFont,
        textColor: .black540,
        numberOfLines: Constants.descriptionNumberOfLines,
        textAlignment: .center,
        lineBreakMode: .byTruncatingTail
    )

    private let linkSharingView = DSLinkSharingMlcView()
    private let separatorView = DSDividerLineView()
    private let borderedButton = BorderedActionsView()

    private let paginationMessageView = DSPaginationMessageMlcView()

    private lazy var loadingView: LottieAnimationView = {
        let lottieView = LottieAnimationView(animation: .named("loader"))
        lottieView.loopMode = .loop
        lottieView.backgroundBehavior = .pauseAndRestore
        return lottieView
    }()

    private let contentView = UIView()

    private var viewModel: DSLinkSharingOrgViewModel?
    
    // MARK: - Lifecycle
    public override func setupSubviews() {
        withHeight(Constants.viewHeight)

        separatorView.setupUI(height: Constants.separatorHeight, color: Constants.separatorColor)

        let textLabelContainer = UIView()
        textLabelContainer.addSubview(textLabel)
        textLabel.anchor(
            top: textLabelContainer.topAnchor,
            leading: textLabelContainer.leadingAnchor,
            trailing: textLabelContainer.trailingAnchor
        )
        textLabel.bottomAnchor.constraint(lessThanOrEqualTo: textLabelContainer.bottomAnchor).isActive = true

        // main view layout
        addSubview(contentView)
        contentView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor
        )

        addSubview(borderedButton)
        borderedButton.withHeight(Constants.buttonHeight)
        borderedButton.anchor(
            top: contentView.bottomAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor
        )
        borderedButton.setupUI(alignment: .center)

        // contentView contents layout
        contentView.addSubview(textLabelContainer)
        textLabelContainer.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            trailing: contentView.trailingAnchor,
            size: Constants.textLabelContainerSize
        )

        let middleCenteredContainer = UIView()
        contentView.addSubview(middleCenteredContainer)
        middleCenteredContainer.anchor(
            leading: contentView.leadingAnchor,
            trailing: contentView.trailingAnchor
        )
        middleCenteredContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

        middleCenteredContainer.addSubview(linkSharingView)
        linkSharingView.anchor(
            top: middleCenteredContainer.topAnchor,
            leading: middleCenteredContainer.leadingAnchor,
            trailing: middleCenteredContainer.trailingAnchor
        )

        middleCenteredContainer.addSubview(separatorView)
        separatorView.anchor(
            top: linkSharingView.bottomAnchor,
            leading: middleCenteredContainer.leadingAnchor,
            trailing: middleCenteredContainer.trailingAnchor,
            padding: .init(top: Constants.separatorViewTopPadding)
        )

        middleCenteredContainer.addSubview(descriptionLabel)
        descriptionLabel.anchor(
            top: linkSharingView.bottomAnchor,
            leading: middleCenteredContainer.leadingAnchor,
            bottom: middleCenteredContainer.bottomAnchor,
            trailing: middleCenteredContainer.trailingAnchor,
            padding: .init(top: Constants.descriptionLabelTopPadding)
        )

        contentView.addSubview(loadingView)
        loadingView.withSize(Constants.loadingIconSize)
        loadingView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

        contentView.addSubview(paginationMessageView)
        paginationMessageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        paginationMessageView.anchor(leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)

        paginationMessageView.setDescriptionAlignment(.center)
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DSLinkSharingOrgViewModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.viewModel?.state.removeObserver(observer: self)
        self.viewModel = viewModel
        
        paginationMessageView.setEventHandler(eventHandler)

        setupState(with: viewModel, eventHandler: eventHandler)

        viewModel.state.observe(observer: self) { [weak self, weak viewModel] state in
            guard let viewModel else { return }
            self?.setupState(with: viewModel, eventHandler: eventHandler)
        }
    }

    // MARK: - Private
    private func setupState(with viewModel: DSLinkSharingOrgViewModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        hideAllViews()

        switch viewModel.state.value {
        case .loading:
            borderedButton.isHidden = true
            paginationMessageView.isHidden = true
            loadingView.isHidden = false
            loadingView.play()
        case .link(let model):
            if let paginationMessageModel = model.paginationMessageMlc {
                showPaginationMessage(paginationMessageModel)
            } else {
                textLabel.isHidden = model.text == nil
                textLabel.text = model.text ?? .empty

                linkSharingView.isHidden = model.linkSharingMlc == nil
                if let linkSharingMlcModel = model.linkSharingMlc {
                    linkSharingView.configure(with: linkSharingMlcModel, eventHandler: eventHandler)
                }

                separatorView.isHidden = false

                descriptionLabel.isHidden = model.description == nil
                descriptionLabel.text = model.description ?? .empty

                let iconButtonViewModels = makeIconButtonViewModels(model: model, eventHandler: eventHandler)
                borderedButton.isHidden = iconButtonViewModels.isEmpty
                borderedButton.configureView(with: iconButtonViewModels)
            }
        case .error(let paginationMessageModel):
            showPaginationMessage(paginationMessageModel)
        }
    }

    private func hideAllViews() {
        loadingView.pause()
        loadingView.isHidden = true
        textLabel.isHidden = true
        descriptionLabel.isHidden = true
        linkSharingView.isHidden = true
        paginationMessageView.isHidden = true
        borderedButton.isHidden = true
        separatorView.isHidden = true
    }

    private func showPaginationMessage(_ model: DSPaginationMessageMlcModel) {
        paginationMessageView.isHidden = false
        paginationMessageView.configure(with: model)
    }

    private func makeIconButtonViewModels(model: DSLinkSharingOrgModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) -> [IconedLoadingStateViewModel] {
        guard let items = model.btnIconPlainGroupMlc?.items else { return [] }

        return items.map {
            let btnPlainIconAtm = $0.btnPlainIconAtm
            let image = UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: btnPlainIconAtm.icon) ?? UIImage()
            return IconedLoadingStateViewModel(
                name: btnPlainIconAtm.label,
                image: image,
                clickHandler: {
                    guard let action = btnPlainIconAtm.action else { return }
                    eventHandler(.action(action))
                },
                componentId: btnPlainIconAtm.componentId
            )
        }
    }
}

// MARK: - Constants
private extension DSLinkSharingOrgView {
    enum Constants {
        static let viewHeight: CGFloat = 390
        static let separatorHeight: CGFloat = 1
        static let buttonHeight: CGFloat = 56
        static let separatorColor = UIColor("#C5D9E9")
        static let textNumberOfLines = 3
        static let descriptionNumberOfLines = 1
        static let textLabelContainerSize = CGSize(width: .zero, height: 48)
        static let descriptionLabelTopPadding: CGFloat = 16
        static let separatorViewTopPadding: CGFloat = 8
        static let loadingIconSize = CGSize(width: 80, height: 80)
    }
}
