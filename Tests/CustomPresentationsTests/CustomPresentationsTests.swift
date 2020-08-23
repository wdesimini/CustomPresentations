import XCTest
@testable import CustomPresentations

#if canImport(UIKit)
final class CustomPresentationsTests: XCTestCase {
    func testInit() {
        let controller = FadeableViewController(targetBackgroundColor: .systemRed)
    }
}
#endif
