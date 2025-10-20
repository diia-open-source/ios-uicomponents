
import UIKit

public class DSIconValueStackView: BaseCodeView {
    private let stack = UIStackView.create(spacing: 24)
    private var imageProvider: DSImageNameProvider? = UIComponentsConfiguration.shared.imageProvider
    
    public override func setupSubviews() {
        addSubview(stack)
        stack.fillSuperview()
    }
    
    public func configure(valueIcons: [DSValueIcon]) {
        stack.safelyRemoveArrangedSubviews()
        if valueIcons.isEmpty { return }
        var index = 0
        while index < valueIcons.count {
            let innerStack = UIStackView.create(
                .horizontal,
                views: [
                    viewForIndex(index: index, inValues: valueIcons),
                    viewForIndex(index: index + 1, inValues: valueIcons),
                    viewForIndex(index: index + 2, inValues: valueIcons)
                ],
                spacing: 24,
                alignment: .fill,
                distribution: .fillEqually)
            stack.addArrangedSubview(innerStack)
            index += 3
        }
    }
    
    private func viewForIndex(index: Int, inValues values: [DSValueIcon]) -> UIView {
        if values.indices.contains(index) {
            let view = DSVerticalIconLabelView()
            view.configure(label: values[index].description,
                           icon: imageProvider?.imageForCode(imageCode: values[index].code))
            return view
        }
        return UIView()
    }
}

public class DSVerticalIconLabelView: BaseCodeView {
    private let imageView = UIImageView()
    private let textLabel = UILabel().withParameters(font: FontBook.mainFont.regular.size(11))
    
    public override func setupSubviews() {
        let imageContainer = UIView().withSize(Constants.iconContainerSize)
        imageContainer.layer.cornerRadius = Constants.iconContainerCornerRadius
        imageView.withSize(Constants.iconSize)
        imageContainer.backgroundColor = .black
        imageContainer.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor).isActive = true
        imageView.tintColor = .white
        textLabel.textAlignment = .center
        let stack = UIStackView.create(views: [imageContainer, textLabel], spacing: Constants.stackSpacing, alignment: .center)
        addSubview(stack)
        stack.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: nil)
        stack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    public func configure(label: String, icon: UIImage?) {
        imageView.image = icon?.withRenderingMode(.alwaysTemplate)
        textLabel.text = label
    }
}

private extension DSVerticalIconLabelView {
    enum Constants {
        static let iconContainerSize = CGSize.init(width: 56, height: 56)
        static let iconContainerCornerRadius: CGFloat = 28
        static let iconSize = CGSize.init(width: 24, height: 24)
        static let stackSpacing: CGFloat = 6
    }
}
