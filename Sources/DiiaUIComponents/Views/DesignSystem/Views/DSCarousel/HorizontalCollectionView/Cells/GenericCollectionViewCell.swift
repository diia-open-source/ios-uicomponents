
import UIKit

public class GenericCollectionViewCell: BaseCollectionNibCell {
    
    private var hostedView: UIView?
    private(set) var viewId: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        contentView.backgroundColor = .clear
    }
    
    public func configure(with view: UIView, for viewId: String? = nil) {
        hostedView?.removeFromSuperview()
        hostedView = view
        addSubview(view)
        view.fillSuperview()
        self.viewId = viewId
    }
    
    public func setContent(isHidden: Bool, animated: Bool) {
        hostedView?.layer.removeAllAnimations()
        let alpha: CGFloat = isHidden ? 0 : 1
        hostedView?.backgroundColor = hostedView?.backgroundColor?.withAlphaComponent(isHidden ? Constants.alphaColor : 1)
        if hostedView?.subviews.first?.alpha != alpha {
            if animated {
                UIView.animate(
                    withDuration: Constants.animationTime,
                    delay: .zero,
                    options: [.allowUserInteraction],
                    animations: { [weak hostedView] in hostedView?.subviews.forEach({$0.alpha = alpha}) }
                )
            } else {
                hostedView?.subviews.forEach({$0.alpha = alpha})
            }
        }
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        hostedView?.removeFromSuperview()
        hostedView = nil
        viewId = nil
    }
}

private extension GenericCollectionViewCell {
    enum Constants {
        static let animationTime: TimeInterval = 0.5
        static let alphaColor: CGFloat = 0.5
    }
}
