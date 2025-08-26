
import UIKit

class EqualTabCollectionCell: BaseCollectionNibCell, NibLoadable {
    
    // MARK: - Outlets
    @IBOutlet weak private var titleLabel: UILabel!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialSetup()
    }
    
    private func initialSetup() {
        titleLabel.font = FontBook.smallHeadingFont
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    // MARK: - Public Methods
    func configure(with title: String) {
        titleLabel.text = title
    }
}
