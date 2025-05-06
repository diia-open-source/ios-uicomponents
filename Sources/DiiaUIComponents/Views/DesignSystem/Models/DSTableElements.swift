import Foundation

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
    
    public init(label: String, icon: DSIconModel?, componentId: String? = nil, description: String? = nil) {
        self.label = label
        self.icon = icon
        self.componentId = componentId
        self.description = description
    }
}

public struct DSTableItem: Codable, Equatable {
    public let tableItemVerticalMlc: DSTableItemVerticalMlc?
    public let tableItemHorizontalMlc: DSTableItemHorizontalMlc?
    public let tableItemPrimaryMlc: DSTableItemPrimaryMlc?
    public let docTableItemHorizontalMlc: DSTableItemHorizontalMlc?
    public let docTableItemHorizontalLongerMlc: DSTableItemHorizontalMlc?
    public let tableItemHorizontalLargeMlc: DSTableItemHorizontalMlc?
    public let smallEmojiPanelMlc: DSSmallEmojiPanelMlcl?
    
    public init(tableItemVerticalMlc: DSTableItemVerticalMlc? = nil,
                tableItemHorizontalMlc: DSTableItemHorizontalMlc? = nil,
                tableItemPrimaryMlc: DSTableItemPrimaryMlc? = nil,
                docTableItemHorizontalMlc: DSTableItemHorizontalMlc? = nil,
                docTableItemHorizontalLongerMlc: DSTableItemHorizontalMlc? = nil,
                tableItemHorizontalLargeMlc: DSTableItemHorizontalMlc? = nil,
                smallEmojiPanelMlc: DSSmallEmojiPanelMlcl? = nil
    ) {
        self.tableItemVerticalMlc = tableItemVerticalMlc
        self.tableItemHorizontalMlc = tableItemHorizontalMlc
        self.tableItemPrimaryMlc = tableItemPrimaryMlc
        self.docTableItemHorizontalMlc = docTableItemHorizontalMlc
        self.docTableItemHorizontalLongerMlc = docTableItemHorizontalLongerMlc
        self.tableItemHorizontalLargeMlc = tableItemHorizontalLargeMlc
        self.smallEmojiPanelMlc = smallEmojiPanelMlc
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
    public let value: String?
    public var secondaryValue: String?
    public var icon: DSIconModel?
    public let valueImage: DSDocumentContentData?
    public let componentId: String?
    
    public init(supportingValue: String? = nil,
                label: String,
                secondaryLabel: String? = nil,
                value: String?,
                secondaryValue: String? = nil,
                icon: DSIconModel? = nil,
                valueImage: DSDocumentContentData? = nil,
                componentId: String? = nil) {
        self.supportingValue = supportingValue
        self.label = label
        self.secondaryLabel = secondaryLabel
        self.value = value
        self.secondaryValue = secondaryValue
        self.icon = icon
        self.valueImage = valueImage
        self.componentId = componentId
    }
}

public struct DSTableItemVerticalMlc: Codable, Equatable {
    public var supportingValue: String?
    public let label: String?
    public var secondaryLabel: String?
    public let value: String?
    public var secondaryValue: String?
    public var icon: DSIconModel?
    public let valueImage: DSDocumentContentData?
    public let valueImages: [String]?
    public let valueIcons: [DSValueIcon]?
    public let componentId: String?
    
    public init(supportingValue: String? = nil,
                label: String? = nil,
                secondaryLabel: String? = nil,
                value: String? = nil,
                secondaryValue: String? = nil,
                icon: DSIconModel? = nil,
                valueImage: DSDocumentContentData? = nil,
                valueImages: [String]? = nil,
                valueIcons: [DSValueIcon]? = nil,
                componentId: String? = nil) {
        self.supportingValue = supportingValue
        self.label = label
        self.secondaryLabel = secondaryLabel
        self.value = value
        self.secondaryValue = secondaryValue
        self.icon = icon
        self.valueImage = valueImage
        self.valueImages = valueImages
        self.valueIcons = valueIcons
        self.componentId = componentId
    }
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
    public let items: [DSItemsModel]?
    public let headingWithSubtitlesMlc: DSHeadingWithSubtitlesModel?
    
    public init(componentId: String? = nil,
                photo: DSDocumentContentData?,
                items: [DSItemsModel]?,
                headingWithSubtitlesMlc: DSHeadingWithSubtitlesModel?) {
        self.photo = photo
        self.items = items
        self.headingWithSubtitlesMlc = headingWithSubtitlesMlc
        self.componentId = componentId
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
    
    public init(value: String, subtitles: [String]?) {
        self.value = value
        self.subtitles = subtitles
    }
}
