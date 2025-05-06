import UIKit
import DiiaCommonTypes

/// design_system_code: tableItemVerticalMlc
public struct DSTableItemVerticalMlcBuilder: DSViewBuilderProtocol {
    public static let modelKey = "tableItemVerticalMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTableItemVerticalMlc = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        if let images = data.valueImages, images.count > 0 {
            let view = HorizontalPhotoCollectionView()
            view.configure(title: nil, imageUrls: images, cellSize: .init(width: Constants.photoSize, height: Constants.photoSize))
            return BoxView(subview: view).withConstraints(insets: paddingType.defaultCollectionPadding())
        } else if let values = data.valueIcons, !values.isEmpty {
            let view = DSIconValueStackView()
            view.configure(valueIcons: values)
            return BoxView(subview: view).withConstraints(insets: paddingType.defaultPadding())
        } else {
            let view = DSTableItemVerticalView()
            view.configure(model: data, eventHandler: eventHandler)
            return BoxView(subview: view).withConstraints(insets: paddingType.defaultPadding())
        }
    }
    
    private enum Constants {
        static let photoSize: CGFloat = 100
    }
}

/// design_system_code: tableItemHorizontalMlc
public struct DSTableItemHorizontalMlcBuilder: DSViewBuilderProtocol {
    public static let modelKey = "tableItemHorizontalMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTableItemHorizontalMlc = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSTableItemHorizontalView()
        view.configure(item: data)
        return BoxView(subview: view).withConstraints(insets: paddingType.defaultPadding())
    }
}

/// design_system_code: tableItemPrimaryMlc
public struct DSTableItemPrimaryMlcBuilder: DSViewBuilderProtocol {
    public static let modelKey = "tableItemPrimaryMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTableItemPrimaryMlc = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSTableItemPrimaryView()
        view.configure(model: data)
        view.setupUI(valueFont: FontBook.mediumHeadingFont)
        return BoxView(subview: view).withConstraints(insets: paddingType.defaultPadding())
    }
}

/// design_system_code: docTableItemHorizontalMlc
public struct DSDocTableItemHorizontalMlcBuilder: DSViewBuilderProtocol {
    public static let modelKey = "docTableItemHorizontalMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTableItemHorizontalMlc = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSTableItemHorizontalView()
        view.setupUI(titleProportion: Constants.titleProportion, numberOfLines: 1)
        view.configure(item: data)
        return BoxView(subview: view).withConstraints(insets: paddingType.defaultPadding())
    }
    
    private enum Constants {
        static let titleProportion: CGFloat = 0.4
    }
}

/// design_system_code: docTableItemHorizontalLongerMlc
public struct DSDocTableItemHorizontalLongerMlcBuilder: DSViewBuilderProtocol {
    public static let modelKey = "docTableItemHorizontalLongerMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTableItemHorizontalMlc = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSTableItemHorizontalView()
        view.setupUI(titleProportion: Constants.titleProportion, numberOfLines: 3)
        view.configure(item: data)
        return BoxView(subview: view).withConstraints(insets: paddingType.defaultPadding())
    }
    
    private enum Constants {
        static let titleProportion: CGFloat = 0.4
    }
}

/// design_system_code: tableItemHorizontalLargeMlc
public struct DSTableItemHorizontalLargeMlcBuilder: DSViewBuilderProtocol {
    public static let modelKey = "tableItemHorizontalLargeMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTableItemHorizontalMlc = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSTableItemHorizontalView()
        view.setupUI(titleFont: FontBook.bigText, valueFont: FontBook.bigText)
        view.configure(item: data)
        return BoxView(subview: view).withConstraints(insets: paddingType.defaultPadding())
    }
    
    private enum Constants {
        static let titleProportion: CGFloat = 0.4
    }
}
