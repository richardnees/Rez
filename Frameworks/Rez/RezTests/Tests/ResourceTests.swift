import XCTest
@testable import Rez

class ResourceTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_simpleResource() {
        let resource = Resource<TestResource>(url: RezTests.simpleResourceURL) { (data, response) -> Result<TestResource> in
            XCTAssertNotNil(data)
            XCTAssertNotNil(response)

            if let name = String(data: data, encoding: .utf8) {
                let testResource = TestResource(name: name)
                return Result.success(testResource)
            } else {
                return Result.failure(ParsingError.noData)
            }
        }
        
        let exp = self.expectation(description: "test_simpleResource")
        
        URLSession.shared.load(resource: resource) { result in
            switch result {
            case let .success(testResource):
                XCTAssertEqual(testResource.name, "A simple test resource name\n")
                exp.fulfill()
            case .failure(_):
                XCTAssertFalse(true, "Test is broken. We should not get a failure here.")
            }
            
        }

        wait(for: [exp], timeout: 1.0)
    }

    func test_JSONResource() {
        let resource = Resource<TestJSONResource>(url: RezTests.JSONResourceURL)
        
        let exp = self.expectation(description: "test_JSONResource")
        
        URLSession.shared.load(resource: resource) { result in
            switch result {
            case let .success(testResource):
                XCTAssertEqual(testResource.name, "Rez")
                exp.fulfill()
            case .failure(_):
                XCTAssertFalse(true, "Test is broken. We should not get a failure here.")
            }
            
        }

        wait(for: [exp], timeout: 1.0)
    }
    
    func test_JSONResourceFailed() {
        let resource = Resource<TestJSONResource>(url: RezTests.JSONResourceBrokenURL)
        
        let exp = self.expectation(description: "test_JSONResourceFailed")
        
        URLSession.shared.load(resource: resource) { result in
            switch result {
            case .success(_):
                XCTAssertFalse(true, "Test is broken. We should get a failure here.")
            case let .failure(error):
                XCTAssertEqual(error.localizedDescription, "The data couldn’t be read because it isn’t in the correct format.")
                exp.fulfill()
            }
            
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_imageResource() {
        let resource = Resource<NSImage>(url: RezTests.imageResourceURL)
        
        let exp = self.expectation(description: "test_imageResource")
        
        URLSession.shared.load(resource: resource) { result in
            switch result {
            case let .success(image):
                XCTAssertNotNil(image)
                exp.fulfill()
            case .failure(_):
                XCTAssertFalse(true, "Test is broken. We should not get a failure here.")
            }
            
        }
        
        wait(for: [exp], timeout: 1.0)
    }

    func test_imageResourceFail() {
        let resource = Resource<NSImage>(url: RezTests.simpleResourceURL)
        
        let exp = self.expectation(description: "test_imageResourceFail")
        
        URLSession.shared.load(resource: resource) { result in
            switch result {
            case .success(_):
                XCTAssertFalse(true, "Test is broken. We should get a failure here.")
            case let .failure(error):
                XCTAssertEqual(error.localizedDescription, ParsingError.imageCreationFailed.localizedDescription)
                exp.fulfill()
            }
            
        }
        
        wait(for: [exp], timeout: 1.0)
    }

    func test_serverNotFound() {
        let resource = Resource<NSImage>(url: URL(string: "https://Asdasasdasdasd")!)
        
        let exp = self.expectation(description: "test_serverNotFound")
        
        URLSession.shared.load(resource: resource) { result in
            switch result {
            case .success(_):
                XCTAssertFalse(true, "Test is broken. We should get a failure here.")
            case let .failure(error):
                XCTAssertEqual(error.localizedDescription, "A server with the specified hostname could not be found.")
                exp.fulfill()
            }
            
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_httpErrorStatus() {
        let resource = Resource<NSImage>(url: URL(string: "https://httpstat.us/500")!)
        
        let exp = self.expectation(description: "test_httpErrorStatus")
        
        URLSession.shared.load(resource: resource) { result in
            switch result {
            case .success(_):
                XCTAssertFalse(true, "Test is broken. We should get a failure here.")
            case let .failure(error as NSError):
                XCTAssertEqual(error.localizedDescription, "HTTP Status Code 500")
                XCTAssertEqual(error.localizedRecoverySuggestion, "https://httpstat.us/500 internal server error")
                exp.fulfill()
            }
            
        }
        
        wait(for: [exp], timeout: 5.0)
    }
}
