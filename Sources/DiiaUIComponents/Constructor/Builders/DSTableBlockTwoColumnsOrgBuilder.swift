
import UIKit
import DiiaCommonTypes

public struct DSTableBlockTwoColumnsOrgBuilder: DSViewBuilderProtocol {
    public static let modelKey = "tableBlockTwoColumnsOrg"
    private let imagesContent: [DSDocumentContentData: UIImage]?
    
    public init(imagesContent: [DSDocumentContentData : UIImage]? = nil) {
        self.imagesContent = imagesContent
    }
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTableBlockTwoColumnPlaneOrg = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSTableBlockTwoColumnsOrgView()
        view.configure(models: data,
                       imagesContent: imagesContent ?? [:],
                       eventHandler: eventHandler)
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: Constants.insets)
        return paddingBox
    }
}

extension DSTableBlockTwoColumnsOrgBuilder {
    enum Constants {
        static let insets = UIEdgeInsets(top: 24, left: .zero, bottom: .zero, right: .zero)
    }
}
