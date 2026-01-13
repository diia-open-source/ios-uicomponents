
import UIKit
import DiiaCommonTypes

public struct DSRecursiveContainerOrgBuilder: DSViewBuilderProtocol {
    public let modelKey = "recursiveContainerOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSRecursiveContainerOrgModel = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = DSRecursiveContainerOrgView()
        if let viewFabric {
            view.setFabric(viewFabric)
        }
        view.setEventHandler(eventHandler)
        view.accessibilityIdentifier = model.componentId
        view.configure(for: model)
        let insets = paddingType.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSRecursiveContainerOrgBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let whiteContainerStr = """
            {
                      "backgroundWhiteOrg": {
                        "componentId": "previous_name_block_template",
                        "items": [
                          {
                            "tableSecondaryHeadingMlc": {
                              "componentId": "previous_name_heading_template",
                              "label": "Попереднє ПІБ",
                              "icon": {
                                "code": "delete",
                                "action": {
                                  "type": "delete_block_item"
                                }
                              }
                            }
                          },
                          {
                            "inputTextMlc": {
                              "componentId": "last_name_before_template",
                              "inputCode": "lastNameBefore",
                              "label": "Прізвище",
                              "mandatory": true,
                              "validation": [
                                {
                                  "regexp": "^[А-ЩЬЮЯҐЄІЇа-щьюяґєії' -]+$",
                                  "flags": [
                                    "g",
                                    "u"
                                  ],
                                  "errorMessage": "Допускаються лише літери українського алфавіту, апостроф, дефіс та пробіл"
                                }
                              ]
                            }
                          },
                          {
                            "inputTextMlc": {
                              "componentId": "first_name_before_template",
                              "inputCode": "firstNameBefore",
                              "label": "Імʼя",
                              "mandatory": true,
                              "validation": [
                                {
                                  "regexp": "^[А-ЩЬЮЯҐЄІЇа-щьюяґєії' -]+$",
                                  "flags": [
                                    "g",
                                    "u"
                                  ],
                                  "errorMessage": "Допускаються лише літери українського алфавіту, апостроф, дефіс та пробіл"
                                }
                              ]
                            }
                          },
                          {
                            "inputTextMlc": {
                              "componentId": "middle_name_before_template",
                              "inputCode": "middleNameBefore",
                              "label": "По батькові",
                              "mandatory": false,
                              "validation": [
                                {
                                  "regexp": "^[А-ЩЬЮЯҐЄІЇа-щьюяґєії' -]+$",
                                  "flags": [
                                    "u"
                                  ],
                                  "errorMessage": "Допускаються лише літери українського алфавіту, апостроф, дефіс та пробіл"
                                }
                              ]
                            }
                          }
                        ]
                      }
                    }
            """

        let itemsStr = """
                [
                                {
                                  "inputTextMlcV2": {
                                    "componentId": "last_name_before_2",
                                    "paddingMode": {
                                      "side": "none",
                                      "top": "none"
                                    },
                                    "inputCode": "fullNamesBefore",
                                    "label": "Прізвище",
                                    "value": "Дієва",
                                    "mandatory": true,
                                    "validation": [
                                      {
                                        "regexp": "^[А-ЩЬЮЯҐЄІЇа-щьюяґєії' -]+$",
                                        "flags": [
                                          "g",
                                          "u"
                                        ],
                                        "errorMessage": "Допускаються лише літери українського алфавіту, апостроф, дефіс та пробіл"
                                      }
                                    ]
                                  }
                                },
                                {
                                  "inputTextMlcV2": {
                                    "componentId": "first_name_before_2",
                                    "paddingMode": {
                                      "side": "none",
                                      "top": "none"
                                    },
                                    "inputCode": "firstNameBefore",
                                    "label": "Ім'я",
                                    "value": "Надія",
                                    "mandatory": true,
                                    "validation": [
                                      {
                                        "regexp": "^[А-ЩЬЮЯҐЄІЇа-щьюяґєії' -]+$",
                                        "flags": [
                                          "g",
                                          "u"
                                        ],
                                        "errorMessage": "Допускаються лише літери українського алфавіту, апостроф, дефіс та пробіл"
                                      }
                                    ]
                                  }
                                },
                                {
                                  "inputTextMlcV2": {
                                    "componentId": "middle_name_before_2",
                                    "paddingMode": {
                                      "side": "none",
                                      "top": "none"
                                    },
                                    "inputCode": "middleNameBefore",
                                    "label": "По батькові",
                                    "value": "Володимирівна",
                                    "hint": "Це поле є необов'язковим",
                                    "mandatory": false,
                                    "validation": [
                                      {
                                        "regexp": "^[А-ЩЬЮЯҐЄІЇа-щьюяґєії' -]+$",
                                        "flags": [
                                          "g",
                                          "u"
                                        ],
                                        "errorMessage": "Допускаються лише літери українського алфавіту, апостроф, дефіс та пробіл"
                                      }
                                    ]
                                  }
                                }
                              ]
            """
        let whiteContainer: AnyCodable? = whiteContainerStr.parseDecodable()
        let items: [AnyCodable]? = itemsStr.parseDecodable()
        let mockBtnWhiteLargeIconAtm = DSBtnPlainIconModel(id: "id", state: .enabled, label: "Додати попереднє ПІБ", icon: "add", action: .init(type: "add_new_template"), componentId: "btn_add_name")
        let model = DSRecursiveContainerOrgModel(
            componentId: "componentId",
            inputCode: "inputCode",
            mandatory: true,
            template: whiteContainer ?? .dictionary([:]),
            items: items ?? [],
            maxNumber: 10,
            btnWhiteLargeIconAtm: mockBtnWhiteLargeIconAtm,
            btnAddOptionAtm: DSBtnAddOptionAtm(
                componentId: "addOption",
                label: "Add Document",
                description: "Upload Document",
                iconLeft: .mock,
                state: .enabled,
                action: nil)
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
