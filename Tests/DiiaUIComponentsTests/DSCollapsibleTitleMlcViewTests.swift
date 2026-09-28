
import XCTest
@testable import DiiaUIComponents

final class DSCollapsibleTitleMlcViewTests: XCTestCase {
    func test_configure_setsAccessibilityIdentifier() {
        let sut = DSCollapsibleTitleMlcView()

        sut.configure(model: DSCollapsibleTitleMlcModel(componentId: "componentId", title: "title"))

        XCTAssertEqual(sut.accessibilityIdentifier, "componentId")
    }

    func test_configure_setsTitleText() {
        let sut = DSCollapsibleTitleMlcView()

        sut.configure(model: DSCollapsibleTitleMlcModel(componentId: "componentId", title: "title"))

        XCTAssertEqual(titleLabel(from: sut).text, "title")
    }

    func test_configure_withoutExpanded_hidesExpandRow() {
        let sut = DSCollapsibleTitleMlcView()

        sut.configure(model: DSCollapsibleTitleMlcModel(componentId: "componentId", title: "title"))

        XCTAssertTrue(expandContainer(from: sut).isHidden)
    }

    func test_configure_withoutExpanded_doesNotLimitTitleLines() {
        let sut = DSCollapsibleTitleMlcView()

        sut.configure(model: DSCollapsibleTitleMlcModel(componentId: "componentId", title: "title"))

        XCTAssertEqual(titleLabel(from: sut).numberOfLines, 0)
    }

    func test_configure_withExpanded_showsExpandRow() {
        let sut = DSCollapsibleTitleMlcView()

        sut.configure(model: DSCollapsibleTitleMlcModel(componentId: "componentId", title: "title", expanded: expandedModel()))

        XCTAssertFalse(expandContainer(from: sut).isHidden)
    }

    func test_configure_collapsedByDefault_limitsTitleToTwoLines() {
        let sut = DSCollapsibleTitleMlcView()

        sut.configure(model: DSCollapsibleTitleMlcModel(componentId: "componentId", title: "title", expanded: expandedModel()))

        XCTAssertEqual(titleLabel(from: sut).numberOfLines, 2)
    }

    func test_configure_collapsedByDefault_showsExpandedActionText() {
        let sut = DSCollapsibleTitleMlcView()

        sut.configure(model: DSCollapsibleTitleMlcModel(componentId: "componentId", title: "title", expanded: expandedModel()))

        XCTAssertEqual(actionLabel(from: sut).text, "Показати більше")
    }

    func test_configure_isExpandedTrue_doesNotLimitTitleLines() {
        let sut = DSCollapsibleTitleMlcView()

        sut.configure(model: DSCollapsibleTitleMlcModel(componentId: "componentId", title: "title", expanded: expandedModel(isExpanded: true)))

        XCTAssertEqual(titleLabel(from: sut).numberOfLines, 0)
    }

    func test_configure_isExpandedTrue_showsCollapsedActionText() {
        let sut = DSCollapsibleTitleMlcView()

        sut.configure(model: DSCollapsibleTitleMlcModel(componentId: "componentId", title: "title", expanded: expandedModel(isExpanded: true)))

        XCTAssertEqual(actionLabel(from: sut).text, "Показати менше")
    }

    func test_configure_withExpanded_notifiesComponentSizeDidChange() {
        let sut = DSCollapsibleTitleMlcView()
        var receivedEvents: [ConstructorItemEvent] = []
        sut.setEventHandler { receivedEvents.append($0) }

        sut.configure(model: DSCollapsibleTitleMlcModel(componentId: "componentId", title: "title", expanded: expandedModel()))

        XCTAssertTrue(receivedEvents.contains {
            if case .componentSizeDidChange = $0 { return true }
            return false
        })
    }

    func test_tap_fromCollapsed_showsFullTitle() {
        let sut = DSCollapsibleTitleMlcView()
        sut.configure(model: DSCollapsibleTitleMlcModel(componentId: "componentId", title: "title", expanded: expandedModel(isExpanded: false)))

        sut.perform(Selector(("onTapped")))

        XCTAssertEqual(titleLabel(from: sut).numberOfLines, 0)
    }

    func test_tap_fromCollapsed_showsCollapsedActionText() {
        let sut = DSCollapsibleTitleMlcView()
        sut.configure(model: DSCollapsibleTitleMlcModel(componentId: "componentId", title: "title", expanded: expandedModel(isExpanded: false)))

        sut.perform(Selector(("onTapped")))

        XCTAssertEqual(actionLabel(from: sut).text, "Показати менше")
    }

    func test_tap_fromExpanded_limitsTitleToTwoLines() {
        let sut = DSCollapsibleTitleMlcView()
        sut.configure(model: DSCollapsibleTitleMlcModel(componentId: "componentId", title: "title", expanded: expandedModel(isExpanded: true)))

        sut.perform(Selector(("onTapped")))

        XCTAssertEqual(titleLabel(from: sut).numberOfLines, 2)
    }

    func test_tap_twice_returnsToCollapsedActionText() {
        let sut = DSCollapsibleTitleMlcView()
        sut.configure(model: DSCollapsibleTitleMlcModel(componentId: "componentId", title: "title", expanded: expandedModel(isExpanded: false)))

        sut.perform(Selector(("onTapped")))
        sut.perform(Selector(("onTapped")))

        XCTAssertEqual(actionLabel(from: sut).text, "Показати більше")
    }

    private func expandedModel(isExpanded: Bool? = nil) -> DSCollapsibleTitleMlcExpanded {
        DSCollapsibleTitleMlcExpanded(expandedText: "Показати більше", collapsedText: "Показати менше", isExpanded: isExpanded)
    }

    private func titleLabel(from view: DSCollapsibleTitleMlcView) -> UILabel {
        label(from: view, label: "titleLabel")
    }

    private func actionLabel(from view: DSCollapsibleTitleMlcView) -> UILabel {
        label(from: view, label: "actionLabel")
    }

    private func expandContainer(from view: DSCollapsibleTitleMlcView) -> UIView {
        let container = Mirror(reflecting: view).children.first {
            $0.label == "expandContainer"
        }?.value as? UIView
        XCTAssertNotNil(container)
        return container ?? UIView()
    }

    private func label(from view: DSCollapsibleTitleMlcView, label: String) -> UILabel {
        let result = Mirror(reflecting: view).children.first {
            $0.label == label
        }?.value as? UILabel
        XCTAssertNotNil(result)
        return result ?? UILabel()
    }
}
