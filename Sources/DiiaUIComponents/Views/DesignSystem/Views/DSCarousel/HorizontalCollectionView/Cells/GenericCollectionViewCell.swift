
import UIKit

class GenericCollectionViewCell: BaseCollectionNibCell {
    
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
    
    func configure(with view: UIView, for viewId: String? = nil) {
        hostedView?.removeFromSuperview()
        hostedView = view
        addSubview(view)
        view.fillSuperview()
        self.viewId = viewId
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        hostedView?.removeFromSuperview()
        hostedView = nil
        viewId = nil
    }
}
