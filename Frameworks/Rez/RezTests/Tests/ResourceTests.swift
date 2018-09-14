import XCTest
@testable import Rez

class ResourceTests: XCTestCase {

    var resourceLoader: ResourceLoader!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        
        resourceLoader = ResourceLoader(session: urlSession)
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
        
        resourceLoader.load(resource: resource) { result in
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
        
        resourceLoader.load(resource: resource) { result in
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
        
        resourceLoader.load(resource: resource) { result in
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
        
        resourceLoader.load(resource: resource) { result in
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
        
        resourceLoader.load(resource: resource) { result in
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
        
        resourceLoader.load(resource: resource) { result in
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
        
        resourceLoader.load(resource: resource) { result in
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
