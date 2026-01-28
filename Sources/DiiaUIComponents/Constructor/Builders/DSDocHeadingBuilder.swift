import UIKit
import DiiaCommonTypes

public struct DSDocHeadingBuilder: DSViewBuilderProtocol {
    public let modelKey = "docHeadingOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let docModel: DSDocumentHeading = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = DSDocumentHeadingView()
        let paddingBox = BoxView(subview: view).withConstraints(insets: Constants.padding)
        view.configure(model: docModel)
        return paddingBox
    }
}

extension DSDocHeadingBuilder {
    private enum Constants {
        static let padding = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
    }
}

// MARK: - Mock
extension DSDocHeadingBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSDocumentHeading(
            headingWithSubtitlesMlc: DSHeadingWithSubtitlesModel(
                value: "value",
                subtitles: ["subtitle1", "subtitle2"],
                componentId: "componentId"
            ),
            headingWithSubtitleWhiteMlc: DSHeadingWithSubtitlesModel(
                value: "value",
                subtitles: ["subtitle1", "subtitle2"],
                componentId: "componentId"
            ),
            docNumberCopyMlc: DSTableItemPrimaryMlc(
                label: "label",
                value: "value",
                icon: .mock
            ),
            docNumberCopyWhiteMlc: DSTableItemPrimaryMlc(
                label: "label",
                value: "value",
                icon: .mock
            ),
            iconAtm: .mock,
            stackMlc: DSStackMlc(
                smallIconAtm: .mock,
                amount: 1
            )
        )
        
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
