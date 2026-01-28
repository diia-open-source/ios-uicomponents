import UIKit
import DiiaCommonTypes

/// design_system_code: tableItemVerticalMlc
public struct DSTableItemVerticalMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "tableItemVerticalMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTableItemVerticalMlc = object.parseValue(forKey: self.modelKey) else { return nil }
        
        if let images = data.valueImages, images.count > 0 {
            let view = HorizontalPhotoCollectionView()
            view.configure(title: nil, imageUrls: images, cellSize: .init(width: Constants.photoSize, height: Constants.photoSize))
            return BoxView(subview: view).withConstraints(insets: paddingType.defaultCollectionPadding(object: object, modelKey: modelKey))
        } else if let values = data.valueIcons, !values.isEmpty {
            let view = DSIconValueStackView()
            view.configure(valueIcons: values)
            return BoxView(subview: view).withConstraints(insets: paddingType.defaultPadding(object: object, modelKey: modelKey))
        } else {
            let view = makeVerticalView(model: data, eventHandler: eventHandler)
            return BoxView(subview: view).withConstraints(insets: paddingType.defaultPadding(object: object, modelKey: modelKey))
        }
    }
    
    func makeVerticalView(model: DSTableItemVerticalMlc, eventHandler: ((ConstructorItemEvent) -> Void)?) -> DSTableItemVerticalView {
        let view = DSTableItemVerticalView()
        view.configure(model: model, eventHandler: eventHandler, urlOpener: UIComponentsConfiguration.shared.urlOpener)
        return view
    }
    
    private enum Constants {
        static let photoSize: CGFloat = 100
    }
}

/// design_system_code: tableItemHorizontalMlc
public struct DSTableItemHorizontalMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "tableItemHorizontalMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTableItemHorizontalMlc = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = makeView(model: data)
        return BoxView(subview: view).withConstraints(insets: paddingType.defaultPadding(object: object, modelKey: modelKey))
    }
    
    func makeView(model: DSTableItemHorizontalMlc) -> DSTableItemHorizontalView {
        let view = DSTableItemHorizontalView()
        view.configure(item: model, urlOpener: UIComponentsConfiguration.shared.urlOpener)
        return view
    }
}

/// design_system_code: tableItemPrimaryMlc
public struct DSTableItemPrimaryMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "tableItemPrimaryMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTableItemPrimaryMlc = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSTableItemPrimaryView()
        view.configure(model: data)
        view.setupUI(valueFont: FontBook.mediumHeadingFont)
        return BoxView(subview: view).withConstraints(insets: paddingType.defaultPadding(object: object, modelKey: modelKey))
    }
}

/// design_system_code: docTableItemHorizontalMlc
public struct DSDocTableItemHorizontalMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "docTableItemHorizontalMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTableItemHorizontalMlc = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSTableItemHorizontalView()
        view.setupUI(titleProportion: Constants.titleProportion, numberOfLines: 1)
        view.configure(item: data, urlOpener: UIComponentsConfiguration.shared.urlOpener)
        return BoxView(subview: view).withConstraints(insets: paddingType.defaultPadding(object: object, modelKey: modelKey))
    }
    
    private enum Constants {
        static let titleProportion: CGFloat = 0.4
    }
}

/// design_system_code: docTableItemHorizontalLongerMlc
public struct DSDocTableItemHorizontalLongerMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "docTableItemHorizontalLongerMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTableItemHorizontalMlc = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSTableItemHorizontalView()
        view.setupUI(titleProportion: Constants.titleProportion, numberOfLines: 3)
        view.configure(item: data, urlOpener: UIComponentsConfiguration.shared.urlOpener)
        return BoxView(subview: view).withConstraints(insets: paddingType.defaultPadding(object: object, modelKey: modelKey))
    }
    
    private enum Constants {
        static let titleProportion: CGFloat = 0.4
    }
}

/// design_system_code: tableItemHorizontalLargeMlc
public struct DSTableItemHorizontalLargeMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "tableItemHorizontalLargeMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTableItemHorizontalMlc = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = makeView(model: data)
        return BoxView(subview: view).withConstraints(insets: paddingType.defaultPadding(object: object, modelKey: modelKey))
    }
    
    func makeView(model: DSTableItemHorizontalMlc) -> UIView {
        let view = DSTableItemHorizontalView()
        view.setupUI(titleFont: FontBook.bigText, valueFont: FontBook.bigText)
        view.configure(item: model, urlOpener: UIComponentsConfiguration.shared.urlOpener)
        return view
    }
}

extension DSTableItemHorizontalLargeMlcBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSTableItemHorizontalMlc(
            supportingValue: "supportingValue",
            label: "label",
            secondaryLabel: "secondaryLabel",
            value: "value",
            secondaryValue: "secondaryValue",
            icon: DSIconModel(
                code: "code",
                accessibilityDescription: "accessibilityDescription",
                componentId: "componentId",
                action: DSActionParameter(
                    type: "iconAction",
                    subtype: "subtype",
                    resource: "resource",
                    subresource: "subresource"),
                isEnable: true
            ),
            valueImage: .photo,
            valueParameters: [
                TextParameter(
                    type: .link,
                    data: TextParameterData(name: "name", alt: "alt", resource: "resource")
                )
            ],
            orientation: true,
            componentId: "componentId"
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
