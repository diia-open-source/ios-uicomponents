
import Foundation
import DiiaCommonTypes

public struct DSTableBlockItemModel: Codable, Equatable {
    public let componentId: String?
    public let tableMainHeadingMlc: DSTableHeadingItemModel?
    public let tableSecondaryHeadingMlc: DSTableHeadingItemModel?
    public let items: [DSTableItem]?
    
    public init(tableMainHeadingMlc: DSTableHeadingItemModel?,
                tableSecondaryHeadingMlc: DSTableHeadingItemModel?,
                items: [DSTableItem]?,
                componentId: String? = nil) {
        self.tableMainHeadingMlc = tableMainHeadingMlc
        self.tableSecondaryHeadingMlc = tableSecondaryHeadingMlc
        self.items = items
        self.componentId = componentId
    }
}

public struct DSTableHeadingItemModel: Codable, Equatable {
    public let label: String
    public let icon: DSIconModel?
    public let componentId: String?
    public let description: String?
    
    public init(label: String, icon: DSIconModel? = nil, componentId: String? = nil, description: String? = nil) {
        self.label = label
        self.icon = icon
        self.componentId = componentId
        self.description = description
    }
    
    static let mock = DSTableHeadingItemModel(
        label: "label",
        icon: .mock,
        componentId: "componentId",
        description: "description(optional)"
    )
}

public struct DSTableItem: Codable, Equatable {
    public let tableItemVerticalMlc: DSTableItemVerticalMlc?
    public let tableItemHorizontalMlc: DSTableItemHorizontalMlc?
    public let tableItemPrimaryMlc: DSTableItemPrimaryMlc?
    public let docTableItemHorizontalMlc: DSTableItemHorizontalMlc?
    public let docTableItemHorizontalLongerMlc: DSTableItemHorizontalMlc?
    public let tableItemHorizontalLargeMlc: DSTableItemHorizontalMlc?
    public let smallEmojiPanelMlc: DSSmallEmojiPanelMlcl?
    public let btnLinkAtm: DSButtonModel?

    public init(tableItemVerticalMlc: DSTableItemVerticalMlc? = nil,
                tableItemHorizontalMlc: DSTableItemHorizontalMlc? = nil,
                tableItemPrimaryMlc: DSTableItemPrimaryMlc? = nil,
                docTableItemHorizontalMlc: DSTableItemHorizontalMlc? = nil,
                docTableItemHorizontalLongerMlc: DSTableItemHorizontalMlc? = nil,
                tableItemHorizontalLargeMlc: DSTableItemHorizontalMlc? = nil,
                smallEmojiPanelMlc: DSSmallEmojiPanelMlcl? = nil,
                btnLinkAtm: DSButtonModel? = nil
    ) {
        self.tableItemVerticalMlc = tableItemVerticalMlc
        self.tableItemHorizontalMlc = tableItemHorizontalMlc
        self.tableItemPrimaryMlc = tableItemPrimaryMlc
        self.docTableItemHorizontalMlc = docTableItemHorizontalMlc
        self.docTableItemHorizontalLongerMlc = docTableItemHorizontalLongerMlc
        self.tableItemHorizontalLargeMlc = tableItemHorizontalLargeMlc
        self.smallEmojiPanelMlc = smallEmojiPanelMlc
        self.btnLinkAtm = btnLinkAtm
    }
}

public struct DSSmallEmojiPanelMlcl: Codable, Equatable {
    public let label: String
    public let icon: DSIconModel?
    
    public init(label: String,
                icon: DSIconModel?) {
        self.label = label
        self.icon = icon
    }
}

public struct DSTableItemPrimaryMlc: Codable, Equatable {
    public let label: String?
    public let value: String
    public let icon: DSIconModel?
    
    public init(label: String?,
                value: String,
                icon: DSIconModel?) {
        self.label = label
        self.value = value
        self.icon = icon
    }
}

public struct DSTableItemHorizontalMlc: Codable, Equatable {
    public var supportingValue: String?
    public let label: String
    public var secondaryLabel: String?
    public let orientation: Bool?
    public let value: String?
    public var secondaryValue: String?
    public var icon: DSIconModel?
    public let valueImage: DSDocumentContentData?
    public let valueParameters: [TextParameter]?
    public let componentId: String?
    
    public init(supportingValue: String? = nil,
                label: String,
                secondaryLabel: String? = nil,
                value: String?,
                secondaryValue: String? = nil,
                icon: DSIconModel? = nil,
                valueImage: DSDocumentContentData? = nil,
                valueParameters: [TextParameter]? = nil,
                orientation: Bool? = nil,
                componentId: String? = nil) {
        self.supportingValue = supportingValue
        self.label = label
        self.secondaryLabel = secondaryLabel
        self.value = value
        self.secondaryValue = secondaryValue
        self.icon = icon
        self.valueImage = valueImage
        self.valueParameters = valueParameters
        self.componentId = componentId
        self.orientation = orientation
    }
    
    static let mock = DSTableItemHorizontalMlc(
        supportingValue: "supportingValue(optional)",
        label: "label",
        secondaryLabel: "secondaryLabel(optional)",
        value: "value(optional)",
        secondaryValue: "secondaryValue(optional)",
        icon: .mock,
        valueImage: .photo,
        valueParameters: [
            TextParameter(
                type: .link,
                data: TextParameterData(name: "name", alt: "alt", resource: "resource")
            )
        ],
        orientation: true,
        componentId: "componentId(optional)"
    )
}

public struct DSTableItemVerticalMlc: Codable, Equatable {
    public var supportingValue: String?
    public let pointSupportingValue: String?
    public let label: String?
    public var secondaryLabel: String?
    public let value: String?
    public var secondaryValue: String?
    public var icon: DSIconModel?
    public let valueImage: DSDocumentContentData?
    public let valueImages: [String]?
    public let valueIcons: [DSValueIcon]?
    public let valueParameters: [TextParameter]?
    public let componentId: String?
    
    public init(supportingValue: String? = nil,
                pointSupportingValue: String? = nil,
                label: String? = nil,
                secondaryLabel: String? = nil,
                value: String? = nil,
                secondaryValue: String? = nil,
                icon: DSIconModel? = nil,
                valueImage: DSDocumentContentData? = nil,
                valueImages: [String]? = nil,
                valueIcons: [DSValueIcon]? = nil,
                valueParameters: [TextParameter]? = nil,
                componentId: String? = nil) {
        self.supportingValue = supportingValue
        self.pointSupportingValue = pointSupportingValue
        self.label = label
        self.secondaryLabel = secondaryLabel
        self.value = value
        self.secondaryValue = secondaryValue
        self.icon = icon
        self.valueImage = valueImage
        self.valueImages = valueImages
        self.valueIcons = valueIcons
        self.valueParameters = valueParameters
        self.componentId = componentId
    }
    
    static let mock = DSTableItemVerticalMlc(
        supportingValue: "supportingValue(optional)",
        pointSupportingValue: "pointSupportingValue(optional)",
        label: "label(optional)",
        secondaryLabel: "secondaryLabel(optional)",
        value: "value(optional)",
        secondaryValue: "secondaryValue(optional)",
        icon: .mock,
        valueImage: .photo,
        valueImages: ["valueImage"],
        valueIcons: [DSValueIcon(code: "code", description: "description")],
        valueParameters: [
            TextParameter(type: .link,
                          data: TextParameterData(name: "name",
                                                  alt: "alt",
                                                  resource: "resourse"))],
        componentId: "componentId"
    )
}

public struct DSValueIcon: Codable, Equatable {
    public let code: String
    public let description: String
    
    public init(code: String,
                description: String) {
        self.code = code
        self.description = description
    }
}

public struct DSTableBlockTwoColumnPlaneOrg: Codable, Equatable {
    public let componentId: String?
    public let photo: DSDocumentContentData?
    public let photoURL: String?
    public let items: [DSItemsModel]?
    public let headingWithSubtitlesMlc: DSHeadingWithSubtitlesModel?
    
    public init(componentId: String? = nil,
                photo: DSDocumentContentData?,
                photoURL: String? = nil,
                items: [DSItemsModel]?,
                headingWithSubtitlesMlc: DSHeadingWithSubtitlesModel?) {
        self.componentId = componentId
        self.photo = photo
        self.photoURL = photoURL
        self.items = items
        self.headingWithSubtitlesMlc = headingWithSubtitlesMlc
    }
}

public enum DSDocumentContentData: String, Codable, Equatable {
    case photo, signature
}

public struct DSItemsModel: Codable, Equatable {
    public let tableItemVerticalMlc: DSTableItemVerticalMlc
    
    public init(tableItemVerticalMlc: DSTableItemVerticalMlc) {
        self.tableItemVerticalMlc = tableItemVerticalMlc
    }
}

public struct DSPhotoItemModel: Codable {
    public let photo: DSDocumentContentData
    
    public init(photo: DSDocumentContentData) {
        self.photo = photo
    }
}

public struct DSHeadingWithSubtitlesModel: Codable, Equatable {
    public let value: String
    public let subtitles: [String]?
    public let componentId: String?
    
    public init(value: String, subtitles: [String]?, componentId: String? = nil) {
        self.value = value
        self.subtitles = subtitles
        self.componentId = componentId
    }
}
