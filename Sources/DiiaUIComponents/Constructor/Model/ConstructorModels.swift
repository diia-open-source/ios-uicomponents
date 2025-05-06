
import Foundation
import DiiaCommonTypes

public struct DSTopGroupOrg: Codable {
    public let titleGroupMlc: DSTopGroupMlc?
    public let navigationPanelMlc: DSNavigationPanelMlc?
    public let chipTabsOrg: DSChipGroupOrg?
    public let scalingTitleMlc: DSScalingTitleMlc?
    public let searchInputMlc: DSSearchModel?
    
    public init(
        titleGroupMlc: DSTopGroupMlc? = nil,
        navigationPanelMlc: DSNavigationPanelMlc? = nil,
        chipTabsOrg: DSChipGroupOrg? = nil,
        scalingTitleMlc: DSScalingTitleMlc? = nil,
        searchInputMlc: DSSearchModel? = nil
    ) {
        self.titleGroupMlc = titleGroupMlc
        self.navigationPanelMlc = navigationPanelMlc
        self.chipTabsOrg = chipTabsOrg
        self.scalingTitleMlc = scalingTitleMlc
        self.searchInputMlc = searchInputMlc
    }
}

public struct DSNavigationPanelMlc: Codable {
    public let label: String?
    public let ellipseMenu: [ContextMenuItem]?
    
    public init(label: String?, ellipseMenu: [ContextMenuItem]?) {
        self.label = label
        self.ellipseMenu = ellipseMenu
    }
}

public struct DSTopGroupMlc: Codable {
    public let componentId: String?
    public let leftNavIcon: DSIconModel?
    public let heroText: String
    public let label: String?
    public let mediumIconRight: DSIconModel?
    
    public init(
        componentId: String? = nil,
        leftNavIcon: DSIconModel? = nil,
        heroText: String,
        label: String? = nil,
        mediumIconRight: DSIconModel? = nil
    ) {
        self.componentId = componentId
        self.leftNavIcon = leftNavIcon
        self.heroText = heroText
        self.label = label
        self.mediumIconRight = mediumIconRight
    }
}

public struct DSBottomGroupOrg: Codable {
    public let componentId: String?
    public let checkboxBtnOrg: DSCheckboxBtnOrg?
    public let btnPrimaryDefaultAtm: DSButtonModel?
    public let btnPrimaryWideAtm: DSButtonModel?
    public let btnPlainAtm: DSButtonModel?
    public let btnStrokeDefaultAtm: DSButtonModel?
    public let btnLoadIconPlainGroupMlc: DSBtnLoadPlainGroupMlc?
    public let btnPrimaryLargeAtm: DSButtonModel?
    
    public init(componentId: String?,
                checkboxBtnOrg: DSCheckboxBtnOrg?,
                btnPrimaryDefaultAtm: DSButtonModel?,
                btnPrimaryWideAtm: DSButtonModel? = nil,
                btnPlainAtm: DSButtonModel?,
                btnStrokeDefaultAtm: DSButtonModel?,
                btnLoadIconPlainGroupMlc: DSBtnLoadPlainGroupMlc?,
                btnPrimaryLargeAtm: DSButtonModel?) {
        self.componentId = componentId
        self.checkboxBtnOrg = checkboxBtnOrg
        self.btnPrimaryDefaultAtm = btnPrimaryDefaultAtm
        self.btnPrimaryWideAtm = btnPrimaryWideAtm
        self.btnPlainAtm = btnPlainAtm
        self.btnStrokeDefaultAtm = btnStrokeDefaultAtm
        self.btnLoadIconPlainGroupMlc = btnLoadIconPlainGroupMlc
        self.btnPrimaryLargeAtm = btnPrimaryLargeAtm
    }
}

public struct DSButtonIconGroupMlc: Codable {
    public let icons: [DSButtonIconAtm]
    public let componentId: String?
    
    public init(icons: [DSButtonIconAtm], componentId: String?) {
        self.icons = icons
        self.componentId = componentId
    }
}

public struct DSButtonIconAtm: Codable {
    public let name: String
    public let image: String
    public let action: DSActionParameter?
    
    public init(name: String, image: String, action: DSActionParameter?) {
        self.name = name
        self.image = image
        self.action = action
    }
}

// MARK: - Media Title
public struct DSMediaTitleModel: Codable {
    public let title: String
    public let secondaryLabel: String
    public let btnPlainIconAtm: DSBtnPlainIconModel
    
    public init(title: String, secondaryLabel: String, btnPlainIconAtm: DSBtnPlainIconModel) {
        self.title = title
        self.secondaryLabel = secondaryLabel
        self.btnPlainIconAtm = btnPlainIconAtm
    }
}

// MARK: - Checkbox Group
public struct DSCheckboxRoundGroupOrg: Codable {
    public let componentId: String?
    public let inputCode: String?
    public let mandatory: Bool?
    public let title: String?
    public let items: [DSCheckboxRoundItem]
    
    public init(componentId: String?,
                title: String?,
                inputCode: String?,
                mandatory: Bool?,
                items: [DSCheckboxRoundItem]) {
        self.componentId = componentId
        self.title = title
        self.inputCode = inputCode
        self.mandatory = mandatory
        self.items = items
    }
}

public struct DSCheckboxRoundItem: Codable {
    public let checkboxRoundMlc: DSCheckboxRoundMlc?
    
    public init(checkboxRoundMlc: DSCheckboxRoundMlc?) {
        self.checkboxRoundMlc = checkboxRoundMlc
    }
}

public struct DSCheckboxRoundMlc: Codable {
    public let id: String?
    public let iconLeft: String?
    public let label: String
    public let description: String?
    public let action: DSActionParameter?
    public let state: DSCheckboxRoundState?
    
    public init(id: String?, iconLeft: String?, label: String, description: String?, action: DSActionParameter?, state: DSCheckboxRoundState?) {
        self.id = id
        self.iconLeft = iconLeft
        self.label = label
        self.description = description
        self.action = action
        self.state = state
    }
}

public enum DSCheckboxRoundState: String, Codable, EnumDecodable {
    public static var defaultValue: DSCheckboxRoundState = .disable
    
    case rest, selected, disable, disableSelected
}

// MARK: - Radio Button Group
public struct DSRadioBtnGroupOrg: Codable {
    public let id: String?
    public let blocker: Bool?
    public let title: String?
    public let condition: String?
    public let items: [DSRadioGroupItem]
    public let componentId: String?
    public let inputCode: String?
    public let btnPlainIconAtm: DSBtnPlainIconModel?
    public let mandatory: Bool?
    
    public init(id: String?, blocker: Bool?, title: String?, condition: String?, items: [DSRadioGroupItem], componentId: String?, inputCode: String?, mandatory: Bool?, btnPlainIconAtm: DSBtnPlainIconModel?) {
        self.id = id
        self.blocker = blocker
        self.title = title
        self.condition = condition
        self.items = items
        self.componentId = componentId
        self.inputCode = inputCode
        self.mandatory = mandatory
        self.btnPlainIconAtm = btnPlainIconAtm
    }
}

public struct DSRadioGroupItem: Codable {
    public let condition: String?
    public let radioBtnMlc: DSRadioButtonMlc
    
    public init(condition: String?, radioBtnMlc: DSRadioButtonMlc) {
        self.condition = condition
        self.radioBtnMlc = radioBtnMlc
    }
}

public struct DSRadioButtonMlc: Codable {
    public let id: String?
    public let label: String
    public let status: String?
    public let type: DSRadioButtonType?
    public let additionalInfo: DSRadioButtonAdditionalInfo?
    public let componentId: String?
    public let logoLeft: String?
    public let logoRight: String?
    public let largeLogoRight: String?
    public let description: String?
    public let isSelected: Bool?
    public let isEnabled: Bool?
    public let dataJson: AnyCodable?
    
    public init(id: String?, label: String, status: String?, type: DSRadioButtonType?, additionalInfo: DSRadioButtonAdditionalInfo?, componentId: String?, logoLeft: String?, logoRight: String?, largeLogoRight: String?, description: String?, isSelected: Bool?, isEnabled: Bool?, dataJson: AnyCodable?) {
        self.id = id
        self.label = label
        self.status = status
        self.type = type
        self.additionalInfo = additionalInfo
        self.componentId = componentId
        self.logoLeft = logoLeft
        self.logoRight = logoRight
        self.largeLogoRight = largeLogoRight
        self.description = description
        self.isSelected = isSelected
        self.isEnabled = isEnabled
        self.dataJson = dataJson
    }
}

public enum DSRadioButtonType: String, Codable {
    case rest
    case selected
    case disable
    case disableSelected
}

public struct DSRadioButtonAdditionalInfo: Codable {
    public let label: String
    public let placeholder: String
    public let value: String?
    public let validation: InputValidationModel?
    
    public init(label: String, placeholder: String, value: String?, validation: InputValidationModel?) {
        self.label = label
        self.placeholder = placeholder
        self.value = value
        self.validation = validation
    }
}

public struct DSCheckboxBtnOrg: Codable {
    public let items: [DSCheckboxBtnItem]
    public let btnPrimaryDefaultAtm: DSButtonModel?
    public let btnPrimaryWideAtm: DSButtonModel?
    public let btnPlainAtm: DSButtonModel?
    public let btnStrokeWideAtm: DSButtonModel?
    public let componentId: String?
    
    public init(items: [DSCheckboxBtnItem],
                btnPrimaryDefaultAtm: DSButtonModel? = nil,
                btnPrimaryWideAtm: DSButtonModel? = nil,
                btnStrokeWideAtm: DSButtonModel? = nil,
                btnPlainAtm: DSButtonModel? = nil,
                componentId: String?) {
        self.items = items
        self.btnPlainAtm = btnPlainAtm
        self.btnPrimaryWideAtm = btnPrimaryWideAtm
        self.btnPrimaryDefaultAtm = btnPrimaryDefaultAtm
        self.btnStrokeWideAtm = btnStrokeWideAtm
        self.componentId = componentId
    }
}

public struct DSCheckboxBtnItem: Codable {
    public let checkboxSquareMlc: DSCheckboxSquareMlc
    
    public init(checkboxSquareMlc: DSCheckboxSquareMlc) {
        self.checkboxSquareMlc = checkboxSquareMlc
    }
}

// MARK: - Notification Carousel
public struct DSSmallNotificationCarouselModel: Codable {
    public let dotNavigationAtm: DSDotNavigationModel
    public let items: [DSSmallNotificationCarouselItem]
    
    public init(dotNavigationAtm: DSDotNavigationModel, items: [DSSmallNotificationCarouselItem]) {
        self.dotNavigationAtm = dotNavigationAtm
        self.items = items
    }
}

public struct DSSmallNotificationCarouselItem: Codable {
    public let smallNotificationMlc: DSSmallNotificationCarouselItemModel?
    public let iconCardMlc: DSIconCardModel?
    
    public init(smallNotificationMlc: DSSmallNotificationCarouselItemModel?, iconCardMlc: DSIconCardModel?) {
        self.smallNotificationMlc = smallNotificationMlc
        self.iconCardMlc = iconCardMlc
    }
}

public struct DSSmallNotificationCarouselItemModel: Codable {
    public let id: String
    public let label: String
    public let text: String
    public let accessibilityDescription: String?
    public let chipStatusAtm: DSCardStatusChipModel?
    public let smallIconUrlAtm: DSIconUrlAtmModel?
    public let action: DSActionParameter?
    
    public init(
        id: String,
        label: String,
        text: String,
        accessibilityDescription: String?,
        chipStatusAtm: DSCardStatusChipModel?,
        smallIconUrlAtm: DSIconUrlAtmModel?,
        action: DSActionParameter?
    ) {
        self.id = id
        self.label = label
        self.text = text
        self.accessibilityDescription = accessibilityDescription
        self.chipStatusAtm = chipStatusAtm
        self.smallIconUrlAtm = smallIconUrlAtm
        self.action = action
    }
}

public struct DSIconCardModel: Codable {
    public let label: String
    public let accessibilityDescription: String?
    public let iconLeft: String
    public let action: DSActionParameter?
    
    public init(label: String, accessibilityDescription: String?, iconLeft: String, action: DSActionParameter?) {
        self.label = label
        self.accessibilityDescription = accessibilityDescription
        self.iconLeft = iconLeft
        self.action = action
    }
}

// MARK: - News Carousel
public struct DSHalvedCardCarouselModel: Codable {
    public let dotNavigationAtm: DSDotNavigationModel
    public let items: [DSHalvedCardCarouselItem]
    
    public init(dotNavigationAtm: DSDotNavigationModel, items: [DSHalvedCardCarouselItem]) {
        self.dotNavigationAtm = dotNavigationAtm
        self.items = items
    }
}

public struct DSHalvedCardCarouselItem: Codable {
    public let halvedCardMlc: DSHalvedCardCarouselItemModel?
    public let iconCardMlc: DSIconCardModel?
    
    public init(halvedCardMlc: DSHalvedCardCarouselItemModel?, iconCardMlc: DSIconCardModel?) {
        self.halvedCardMlc = halvedCardMlc
        self.iconCardMlc = iconCardMlc
    }
}

public struct DSHalvedCardCarouselItemModel: Codable {
    public let id: String?
    public let title: String
    public let label: String
    public let accessibilityDescription: String?
    public let image: String
    public let action: DSActionParameter?
    
    public init(id: String?, title: String, label: String, accessibilityDescription: String?, image: String, action: DSActionParameter?) {
        self.id = id
        self.title = title
        self.label = label
        self.accessibilityDescription = accessibilityDescription
        self.image = image
        self.action = action
    }
}

// MARK: - Black Card
public struct DSBlackCardModel: Codable {
    public let smallIconAtm: DSIconModel?
    public let iconAtm: DSIconModel?
    public let doubleIconAtm: DSIconModel?
    public let title: String
    public let label: String
    public let action: DSActionParameter
    
    public init(smallIconAtm: DSIconModel? = nil,
         iconAtm: DSIconModel? = nil,
         doubleIconAtm: DSIconModel? = nil,
         title: String,
         label: String,
         action: DSActionParameter) {
        self.smallIconAtm = smallIconAtm
        self.iconAtm = iconAtm
        self.doubleIconAtm = doubleIconAtm
        self.title = title
        self.label = label
        self.action = action
    }
}

// MARK: - White Card
public struct DSWhiteCardModel: Codable {
    public let image: String?
    public let smallIconAtm: DSIconModel?
    public let iconAtm: DSIconModel?
    public let largeIconAtm: DSIconModel?
    public let doubleIconAtm: DSIconModel?
    public let title: String?
    public let label: String
    public let accessibilityDescription: String?
    public let action: DSActionParameter
    
    public init(image: String? = nil,
                smallIconAtm: DSIconModel? = nil,
                iconAtm: DSIconModel? = nil,
                doubleIconAtm: DSIconModel? = nil,
                largeIconAtm: DSIconModel? = nil,
                title: String?,
                label: String,
                accessibilityDescription: String? = nil,
                action: DSActionParameter) {
        self.image = image
        self.smallIconAtm = smallIconAtm
        self.iconAtm = iconAtm
        self.doubleIconAtm = doubleIconAtm
        self.largeIconAtm = largeIconAtm
        self.title = title
        self.label = label
        self.accessibilityDescription = accessibilityDescription
        self.action = action
    }
}

// MARK: - Image Card
public struct DSImageCardModel: Codable {
    public let componentId: String?
    public let image: String
    public let label: String
    public let imageAltText: String?
    public let iconRight: String
    public let action: DSActionParameter
    
    public init(
        componentId: String,
        image: String,
        label: String,
        imageAltText: String?,
        iconRight: String,
        action: DSActionParameter
    ) {
        self.image = image
        self.label = label
        self.imageAltText = imageAltText
        self.iconRight = iconRight
        self.action = action
        self.componentId = componentId
    }
}

public struct DSImageCardMlc: Codable {
    public let imageCardMlc: DSImageCardModel

    public init(imageCardMlc: DSImageCardModel) {
        self.imageCardMlc = imageCardMlc
    }
}

// MARK: - Vertical Card Carousel
public struct DSVerticalCardCarouselModel: Codable {
    public let items: [DSVerticalCardCarouselItem]
    
    public init(items: [DSVerticalCardCarouselItem]) {
        self.items = items
    }
}

public struct DSVerticalCardCarouselItem: Codable {
    public let verticalCardMlc: DSVerticalCardCarouselItemModel
    
    public init(verticalCardMlc: DSVerticalCardCarouselItemModel) {
        self.verticalCardMlc = verticalCardMlc
    }
}

public struct DSVerticalCardCarouselItemModel: Codable {
    public let id: String?
    public let title: String
    public let image: String
    public let badgeCounterAtm: DSBadgeCounterModel
    public let action: DSActionParameter?
    
    public init(id: String?, title: String, image: String, badgeCounterAtm: DSBadgeCounterModel, action: DSActionParameter?) {
        self.id = id
        self.title = title
        self.image = image
        self.badgeCounterAtm = badgeCounterAtm
        self.action = action
    }
}

// MARK: - Button Icon Rounded Group
public struct DSButtonIconRoundedGroupModel: Codable {
    public let items: [DSButtonIconRoundedItem]
    
    public init(items: [DSButtonIconRoundedItem]) {
        self.items = items
    }
}

public struct DSButtonIconRoundedItem: Codable {
    public let btnIconRoundedMlc: DSButtonIconRoundedItemModel
    
    public init(btnIconRoundedMlc: DSButtonIconRoundedItemModel) {
        self.btnIconRoundedMlc = btnIconRoundedMlc
    }
}

public struct DSButtonIconRoundedItemModel: Codable {
    public let label: String
    public let icon: String
    public let action: DSActionParameter
    
    public init(label: String, icon: String, action: DSActionParameter) {
        self.label = label
        self.icon = icon
        self.action = action
    }
}

// MARK: - Article Pic Carousel
public struct DSArticlePicCarouselModel: Codable {
    public let dotNavigationAtm: DSDotNavigationModel
    public let items: [DSArticlePicCarouselItem]
    
    public init(dotNavigationAtm: DSDotNavigationModel, items: [DSArticlePicCarouselItem]) {
        self.dotNavigationAtm = dotNavigationAtm
        self.items = items
    }
}

public struct DSArticlePicCarouselItem: Codable {
    public let articlePicAtm: DSImageData?
    public let articleVideoMlc: DSVideoData?
    
    public init(articlePicAtm: DSImageData?, articleVideoMlc: DSVideoData?) {
        self.articlePicAtm = articlePicAtm
        self.articleVideoMlc = articleVideoMlc
    }
}

public struct DSImageData: Codable {
    public let image: String
    
    public init(image: String) {
        self.image = image
    }
}

public struct DSVideoData: Codable {
    public let componentId: String?
    public let source: String
    public let playerBtnAtm: DSPlayerBtnModel?
    public let fullScreenVideoOrg: DSFullScreenVideoOrg?
    public let thumbnail: String?
    
    public init(componentId: String?,
                source: String,
                playerBtnAtm: DSPlayerBtnModel?,
                fullScreenVideoOrg: DSFullScreenVideoOrg?,
                thumbnail: String?) {
        self.componentId = componentId
        self.source = source
        self.playerBtnAtm = playerBtnAtm
        self.fullScreenVideoOrg = fullScreenVideoOrg
        self.thumbnail = thumbnail
    }
}

public struct DSFullScreenVideoOrg: Codable {
    public let componentId: String?
    public let source: String
    public let playerBtnAtm: DSPlayerBtnModel?
    public let btnPrimaryDefaultAtm: DSButtonModel?
    public let btnPlainAtm: DSButtonModel?
    
    public init(componentId: String?,
                source: String,
                playerBtnAtm: DSPlayerBtnModel?,
                btnPrimaryDefaultAtm: DSButtonModel?,
                btnPlainAtm: DSButtonModel?) {
        self.componentId = componentId
        self.source = source
        self.playerBtnAtm = playerBtnAtm
        self.btnPrimaryDefaultAtm = btnPrimaryDefaultAtm
        self.btnPlainAtm = btnPlainAtm
    }
}
public struct DSPlayerBtnModel: Codable {
    public let type: String
    public let icon: String
    
    public init(type: String, icon: String) {
        self.type = type
        self.icon = icon
    }
}

public struct DSDotNavigationModel: Codable {
    public let count: Int
    
    public init(count: Int) {
        self.count = count
    }
}

public struct DSDetailsTextValueMlc: Codable {
    public let logo: String?
    public let label: String
    public let value: String
    public let icon: DSDetailsTextValueIconModel?
    
    public init(logo: String?, label: String, value: String, icon: DSDetailsTextValueIconModel?) {
        self.logo = logo
        self.label = label
        self.value = value
        self.icon = icon
    }
}

public struct DSDetailsTextValueIconModel: Codable {
    public let code: String
    public let action: DSActionParameter?
    
    public init(code: String, action: DSActionParameter?) {
        self.code = code
        self.action = action
    }
}
