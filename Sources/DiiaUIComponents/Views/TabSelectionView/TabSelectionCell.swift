
import UIKit

public final class TabSelectionCell: BaseCollectionNibCell, NibLoadable {
    
    public static let nib = UINib(nibName: reuseID, bundle: Bundle.module)

    // MARK: - Outlets
    @IBOutlet weak private var titleLabel: UILabel!
    
    // MARK: - Properties
    var titleWidth: CGFloat {
        return titleLabel.text?.width(
            withConstrainedHeight: titleLabel.bounds.height,
            font: titleLabel.font
        ) ?? 0
    }

    // MARK: - LifeCycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        initialSetup()
    }
    
    private func initialSetup() {
        titleLabel.font = FontBook.smallHeadingFont
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    // MARK: - Public Methods
    func configure(with title: String) {
        titleLabel.text = title
    }

}
