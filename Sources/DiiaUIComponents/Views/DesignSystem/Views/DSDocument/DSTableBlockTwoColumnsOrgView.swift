import UIKit

/// design_system_code: tableBlockTwoColumnsOrg

public class DSTableBlockTwoColumnsOrgView: BaseCodeView {
    
    private let tableBlockTwoColumnsOrgView = DSTableBlockTwoColumnsPlaneOrgView()
    
    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        let backgroundView = UIView()
        backgroundView.layer.cornerRadius = Constants.cornerRadius
        backgroundView.backgroundColor = .white
        addSubview(backgroundView)
        backgroundView.fillSuperview(padding: Constants.padding)
        backgroundView.addSubview(tableBlockTwoColumnsOrgView)
        tableBlockTwoColumnsOrgView.fillSuperview(padding: .init(top: Constants.spacing,
                                                                 left: 0,
                                                                 bottom: Constants.spacing,
                                                                 right: 0))
    }
    
    public func configure(models: DSTableBlockTwoColumnPlaneOrg, imagesContent: [DSDocumentContentData: UIImage], eventHandler: ((ConstructorItemEvent) -> Void)? = nil) {
        self.accessibilityIdentifier = models.componentId
        tableBlockTwoColumnsOrgView.configure(models: models, imagesContent: imagesContent, eventHandler: eventHandler)
    }
    
    private func setupUI() {
        
    }
    
}

extension DSTableBlockTwoColumnsOrgView {
    enum Constants {
        static let padding = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        static let spacing: CGFloat = 16
        static let cornerRadius: CGFloat = 16
        static let verticalStackSpace: CGFloat = 12
    }
}
