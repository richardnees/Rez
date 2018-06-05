import Foundation

class RezTests {
    static let bundle = Bundle(for: RezTests.self)
}

extension RezTests {
    static let appFolderURL = URL(fileURLWithPath: "Applications")
    static let simpleResourceURL = RezTests.bundle.url(forResource: "TestResource", withExtension: "txt")!
    static let imageResourceURL = RezTests.bundle.url(forResource: "TestImage", withExtension: "png")!
    static let JSONResourceURL = RezTests.bundle.url(forResource: "TestJSONResource", withExtension: "json")!
    static let JSONResourceBrokenURL = RezTests.bundle.url(forResource: "TestJSONResourceBroken", withExtension: "json")!
}
