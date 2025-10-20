
import UIKit
import DiiaCommonTypes

public struct DSMediaUploadModel: Codable {
    public let componentId: String?
    public let title: String?
    public let description: String?
    public let maxCount: Int?
    public let btnPlainIconAtm: DSBtnPlainIconModel
    
    public init(title: String?,
                description: String?,
                maxCount: Int?,
                btnPlainIconAtm: DSBtnPlainIconModel,
                componentId: String? = nil) {
        self.title = title
        self.description = description
        self.maxCount = maxCount
        self.btnPlainIconAtm = btnPlainIconAtm
        self.componentId = componentId
    }
}

public final class DSMediaUploadViewModel: NSObject {
    public let componentId: String?
    public let title: String?
    public let mediaDescription: String?
    public let maxCount: Int
    public let action: Action
    public let subitems: Observable<[DSSmallPicAtmViewModel]> = .init(value: [])
    public let onChange: Callback?
    
    public init(title: String?, description: String?, maxCount: Int = 10, componentId: String? = nil, action: Action, onChange: Callback?) {
        self.title = title
        self.mediaDescription = description
        self.maxCount = maxCount
        self.action = action
        self.onChange = onChange
        self.componentId = componentId
        super.init()
    }
    
    public func uploadedMediaIds() -> [String] {
        var mediaIds: [String] = []
        subitems.value.forEach { item in
            switch item.state.value {
            case .loaded(let id):
                mediaIds.append(id)
            default:
                break
            }
        }
        return mediaIds
    }
    
    public func isValid() -> Bool {
        let mediaIds = uploadedMediaIds()
        return mediaIds.count == subitems.value.count && mediaIds.count > 0
    }
}

/// design_system_code: mediaUploadGroupOrg
public final class DSMediaUploadView: BaseCodeView {
    private let mainStack =  UIStackView.create(spacing: Constants.stackSpacing)
    private let collectionStack = UIStackView.create(spacing: Constants.stackSpacing)
    private let buttonStack = UIStackView.create()
    private let titleStack = UIStackView.create(spacing: Constants.titleStackSpacing).withMargins(Constants.titleStackMargins)
    private let separatorView = UIView().withHeight(Constants.separatorHeight)
    private let titleLabel = UILabel().withParameters(font: FontBook.usualFont)
    private let mediaDescriptionLabel = UILabel().withParameters(font: FontBook.statusFont, textColor: .black.withAlphaComponent(0.5))
    private let addButton = ActionButton()
    
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = Constants.collectionViewSectionInsets
        
        return layout
    }()
    
    private var viewModel: DSMediaUploadViewModel?
    
    override public func setupSubviews() {
        self.layer.cornerRadius = Constants.cornerRadius
        addSubview(mainStack)
        mainStack.fillSuperview()
        separatorView.backgroundColor = Constants.separatorColor
        collectionView.showsHorizontalScrollIndicator = false
        collectionStack.addArrangedSubviews([
            collectionView
        ])
        buttonStack.addArrangedSubviews([
            separatorView,
            addButton
        ])
        titleStack.addArrangedSubviews([
            titleLabel,
            mediaDescriptionLabel
        ])
        mainStack.addArrangedSubviews([
            titleStack,
            collectionStack,
            buttonStack
        ])
        
        addButton.type = .full
        addButton.setupUI(font: FontBook.usualFont, bordered: false, textColor: .black, secondaryColor: .clear, imageRenderingMode: .alwaysOriginal, contentHorizontalAlignment: .center)
        addButton.withHeight(Constants.buttonHeight)
        addButton.titleEdgeInsets = Constants.buttonTitleEdgeInsets
        collectionView.withHeight(Constants.photoSize)
        collectionView.register(cellType: DSSmallPicAtmCell.self)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    public func configure(viewModel: DSMediaUploadViewModel) {
        self.accessibilityIdentifier = viewModel.componentId
        self.viewModel?.subitems.removeObserver(observer: self)
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        titleLabel.isHidden = viewModel.title?.count ?? 0 == 0
        mediaDescriptionLabel.text = viewModel.mediaDescription
        mediaDescriptionLabel.isHidden = viewModel.mediaDescription?.count ?? 0 == 0
        addButton.action = viewModel.action
        
        viewModel.subitems.observe(observer: self, { [weak self] items in
            self?.updateItems(items: items)
        })
    }
    
    private func updateItems(items: [DSSmallPicAtmViewModel]) {
        collectionStack.isHidden = items.isEmpty
        collectionView.isHidden = items.isEmpty
        collectionView.reloadData()
        validateAddButton(items)
    }
    
    private func validateAddButton(_ items: [DSSmallPicAtmViewModel]) {
        let isBelowMax = items.count < viewModel?.maxCount ?? 0 ? true : false
        addButton.isEnabled = isBelowMax
        addButton.setTitleColor(isBelowMax ? .black : Constants.disabledСolor, for: .disabled)
    }
}

extension DSMediaUploadView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return viewModel?.subitems.value.count ?? 0
        }
        
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let items = viewModel?.subitems.value,
              items.indices.contains(indexPath.item)
        else {
            return UICollectionViewCell()
        }
        let cell: DSSmallPicAtmCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(viewModel: items[indexPath.item])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: Constants.photoSize, height: Constants.photoSize)
    }
}

private extension DSMediaUploadView {
    enum Constants {
        static let buttonTitleEdgeInsets: UIEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 0)
        static let collectionViewSectionInsets: UIEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)
        static let titleStackMargins: UIEdgeInsets = .init(top: 16, left: 16, bottom: 0, right: 16)
        static let stackSpacing: CGFloat = 16
        static let titleStackSpacing: CGFloat = 4
        static let photoSize: CGFloat = 112
        static let cornerRadius: CGFloat = 8
        static let separatorColor = UIColor("#E2ECF4")
        static let disabledСolor = UIColor.black.withAlphaComponent(0.3)
        static let buttonHeight: CGFloat = 56
        static let separatorHeight: CGFloat = 2
    }
}
