
import DiiaCommonTypes
import UIKit

/// DS_Code: greyTitleAtm
public struct DSGrayTitleAtmBulder: DSViewBuilderProtocol {
    public let modelKey = "greyTitleAtm"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSGreyTitleAtmModel = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = DSGreyTitleAtm()
        view.configure(with: data)
        
        let box = BoxView(subview: view).withConstraints(insets: padding.insets(for: object, modelKey: modelKey, defaultInsets: Constants.edgeInsets))
        return box
    }
}

extension DSGrayTitleAtmBulder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSGreyTitleAtmModel(
            componentId: "componentId",
            label: "Grey Title Text"
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

extension DSGrayTitleAtmBulder {
    private enum Constants {
        static let edgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
    }
}
