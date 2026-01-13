
import UIKit
import DiiaCommonTypes

/// design_system_code: textBlockOrg
public struct DSTextBlockViewBuilder: DSViewBuilderProtocol {
    public let modelKey = "textBlockOrg"
    
    public func makeView(
        from object: AnyCodable,
        withPadding paddingType: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let data: DSTextBlockModel = object.parseValue(forKey: self.modelKey) else { return nil }

        let textView = DSTextBlockView()
        if let viewFabric {
            textView.setFabric(viewFabric)
        }
        textView.configure(with: DSTextBlockViewModel(model: data, eventHandler: eventHandler))
        let padding = paddingType.defaultPaddingV2(object: object, modelKey: modelKey)
        
        let paddingBox = BoxView(subview: textView).withConstraints(insets: padding)
        textView.accessibilityIdentifier = data.componentId
        return paddingBox
    }
}

extension DSTextBlockViewBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let listItemsStr = """
[
  {
    "tableItemVerticalMlc": {
        "componentId": "table_item_vertical_1",
        "label": "Уточнення персональних даних;"
    }
  },
  {
    "tableItemVerticalMlc": {
        "componentId": "table_item_vertical_2",
        "label": "Підпис заяви про створення Бізнес Дія. Підпису за допомогою особистого Дія.Підпису;"
    }
  },
  {
    "tableItemVerticalMlc": {
        "componentId": "table_item_vertical_3",
        "label": "Оплата послуги;"
    }
  },
  {
    "tableItemVerticalMlc": {
        "componentId": "table_item_vertical_4",
        "label": "Активація Бізнес Дія.Підпису."
    }
  },
]
"""
        let listItems: [AnyCodable] = listItemsStr.parseDecodable() ?? []
        let itemsStr = """
[
  {
      "textItemHorizontalMlc": {
          "componentId": "text_item_horizontal_1",
          "label": "Час активації:",
          "value": "до 20 хв"
      }
  },
  {
      "textItemHorizontalMlc": {
          "componentId": "text_item_horizontal_2",
          "label": "Вартість однієї активації: ",
          "value": "110 грн"
      }
  }
]
"""
        let items: [AnyCodable] = itemsStr.parseDecodable() ?? []
        
        let model = DSTextBlockModel(
            componentId: "componentId",
            squareChipStatusAtm: DSSquareChipStatusModel(
                componentId: "componentId",
                name: "name",
                type: .blue
            ),
            title: "title",
            text: "text link",
            items: items,
            listItems: listItems,
            parameters: [.init(type: .link, data: .init(name: "link", alt: "link", resource: "https://example.com"))],
            attentionIconMessageMlc: .mock
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
