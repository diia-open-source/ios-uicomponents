
import UIKit
import DiiaCommonTypes

/// design_system_code: inputNumberFractionalMlc
public struct DSInputNumberFractionalViewBuilder: DSViewBuilderProtocol {
    public let modelKey = "inputNumberFractionalMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSInputNumberMlc = object.parseValue(forKey: self.modelKey) else { return nil }

        let inputView = TitledTextFieldViewV2()

        var validators: [TextValidationErrorGenerator] = []
        if let errorMessage = data.errorMessage {
            validators.append(.init(type: .number(min: data.minValue, max: data.maxValue), error: errorMessage))
            
            if let minIntegerCount = data.minIntegerCount {
                validators.append(
                    .init(
                        type: .minIntegerDigits(min: minIntegerCount),
                        error: errorMessage
                    )
                )
            }
        }
        
        let shouldChangeCharacters = data.decimalCount.map {
            TextInputValidationHelper.decimalPlacesValidator(maxDecimalPlaces: $0)
        }
        
        let autoFillDecimal: Bool = {
            guard data.autoFillDecimal == true else { return false }
            guard let decimalCount = data.decimalCount, decimalCount > 0 else {
                return false
            }
            return true
        }()
        
        let onEndEditing: ((String) -> Void)?
        if autoFillDecimal {
            onEndEditing = { [weak textField = inputView.textField] text in
                guard let textField = textField, !text.isEmpty else { return }
                let padded = Self.padded(text: text, decimalCount: data.decimalCount ?? 0)
                guard padded != text else { return }
                textField.text = padded
                textField.sendActions(for: .editingChanged)
            }
        } else {
            onEndEditing = nil
        }

        var value: String? = nil
        if let numberValue = data.value {
            value = Self.formattedText(for: numberValue, decimalCount: data.decimalCount, padWithZeros: autoFillDecimal)
        }
        
        inputView.configure(viewModel: TitledTextFieldViewModel(
            id: data.componentId,
            title: data.label,
            placeholder: data.placeholder ?? .empty,
            validators: validators,
            mandatory: data.mandatory,
            defaultText: value,
            instructionsText: data.hint,
            keyboardType: .decimalPad,
            onChangeText: { text in
                eventHandler(.inputChanged(.init(
                    inputCode: data.inputCode ?? self.modelKey,
                    inputData: .string(text))))
            },
            shouldChangeCharacters: shouldChangeCharacters,
            onEndEditing: onEndEditing
        ))

        let paddingBox = BoxView(subview: inputView).withConstraints(insets: paddingType.defaultPadding(object: object, modelKey: modelKey))
        return paddingBox
    }
}

private extension DSInputNumberFractionalViewBuilder {
    static func formattedText(for value: Double, decimalCount: Int?, padWithZeros: Bool) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "uk_UA")
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        if let decimalCount = decimalCount {
            formatter.maximumFractionDigits = decimalCount
            formatter.minimumFractionDigits = padWithZeros ? decimalCount : 0
        }
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    static func padded(text: String, decimalCount: Int) -> String {
        guard let sepIndex = text.firstIndex(where: { $0 == "," || $0 == "." }) else {
            return text + "," + String(repeating: "0", count: decimalCount)
        }
        let fractionalCount = text.distance(from: text.index(after: sepIndex), to: text.endIndex)
        let missing = decimalCount - fractionalCount
        guard missing > 0 else { return text }
        return text + String(repeating: "0", count: missing)
    }
}


// MARK: - Mock
extension DSInputNumberFractionalViewBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSInputNumberMlc(
            componentId: "componentId",
            inputCode: "inputCode",
            label: "label",
            placeholder: "placeholder",
            hint: "hint",
            value: 0,
            maxValue: 100,
            minValue: 0,
            mandatory: true,
            errorMessage: "errorMessage",
            mask: "mask",
            iconRight: .mock,
            decimalCount: 2,
            minIntegerCount: 1,
            autoFillDecimal: true
        )
        
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
