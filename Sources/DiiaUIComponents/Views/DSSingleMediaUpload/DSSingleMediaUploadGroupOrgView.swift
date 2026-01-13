
import UIKit
import DiiaCommonTypes

//ds code: singleMediaUploadGroupOrg
public final class DSSingleMediaUploadGroupOrgView: BaseCodeView {
    private let mainStack = UIStackView.create()
    private let itemsStack = UIStackView.create(alignment: .center).withMargins(Constants.paddings)
    private let titleStack = UIStackView.create(spacing: Constants.titleStackSpacing).withMargins(Constants.paddings)
    private let separatorView = DSSeparatorView()
    private let photoView = DSSingleMediaUploadPhotoView()
    private let buttonStack = UIStackView.create()
    private let addButton = ActionButton()
    private let titleLabel = UILabel().withParameters(font: FontBook.usualFont)
    private let descriptionLabel = UILabel().withParameters(font: FontBook.statusFont, textColor: Constants.detailsTextColor)
    private var viewModel: DSFileUploadViewModel?
    
    public override func setupSubviews() {
        self.backgroundColor = .white
        self.layer.cornerRadius = Constants.cornerRadius
        
        addSubview(mainStack)
        mainStack.fillSuperview()
        photoView.withSize(Constants.threeFourIconSize)
        buttonStack.addArrangedSubviews([
            addButton
        ])
        
        titleStack.addArrangedSubviews([
            titleLabel,
            descriptionLabel
        ])
        
        itemsStack.addArrangedSubview(photoView)
        
        mainStack.addArrangedSubviews([
            titleStack,
            separatorView,
            itemsStack,
            buttonStack
        ])
        
        photoView.withBorder(width: Constants.borderWidth, color: Constants.borderColor)
        photoView.layer.cornerRadius = Constants.cornerRadius
        
        addButton.type = .full
        addButton.setupUI(font: FontBook.usualFont, bordered: false, textColor: .black, secondaryColor: .clear, imageRenderingMode: .alwaysOriginal, contentHorizontalAlignment: .center)
        addButton.withHeight(Constants.buttonHeight)
        addButton.titleEdgeInsets = Constants.buttonTitleEdgeInsets
    }
    
    public func configure(with viewModel: DSFileUploadViewModel) {
        self.viewModel?.subitems.removeObserver(observer: self)
        self.viewModel = viewModel
        setupIconSize(with: viewModel.aspectRatio ?? .threeFour)
        titleLabel.text = viewModel.title
        titleLabel.isHidden = viewModel.title?.count ?? 0 == 0
        descriptionLabel.text = viewModel.descriptionText
        descriptionLabel.isHidden = viewModel.descriptionText?.count ?? 0 == 0
        addButton.action = viewModel.action
        addButton.isHidden = viewModel.action == nil
        
        viewModel.subitems.observe(observer: self, { [weak self] photos in
            self?.viewModel?.onChange?()
            self?.updateItems(photos: photos)
        })
    }
    
    private func updateItems(photos: [DSFileUploadItemViewModel]) {
        itemsStack.isHidden = photos.isEmpty
        validateAddButton(photos: photos)
        guard let photo = photos.first else { return }
        photoView.configure(with: photo)
       
    }
    
    private func validateAddButton(photos: [DSFileUploadItemViewModel]) {
        buttonStack.isHidden = photos.count != 0
    }
    
    public func setupIconSize(with type: FileAspectRatio) {
        switch type {
        case .square:
            photoView.withSize(Constants.squareIconSize)
        case .threeFour:
            photoView.withSize(Constants.threeFourIconSize)
        }
        layoutIfNeeded()
    }
}

extension DSSingleMediaUploadGroupOrgView: DSInputComponentProtocol {
    public func isValid() -> Bool {
        guard let vm = viewModel else { return false }
        return vm.isValid()
    }
    
    public func inputCode() -> String {
        return ""
    }
    
    public func inputData() -> AnyCodable? {
        return nil
    }
}

private extension DSSingleMediaUploadGroupOrgView {
    enum Constants {
        static let borderColor = UIColor.black.withAlphaComponent(0.1)
        static let borderWidth: CGFloat = 1
        static let buttonHeight: CGFloat = 56
        static let buttonTitleEdgeInsets: UIEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 0)
        static let detailsTextColor = UIColor.black.withAlphaComponent(0.5)
        static let cornerRadius: CGFloat = 8
        static let paddings = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let squareIconSize = CGSize(width: 112, height: 112)
        static let threeFourIconSize = CGSize(width: 132, height: 176)
        static let titleStackSpacing: CGFloat = 4
    }
}

