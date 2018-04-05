import Foundation

public enum HTTPStatusError: Error {
    case httpError(code: Int, url: URL)
}

extension HTTPStatusError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case let .httpError(code, _):
            return NSLocalizedString("HTTP Status Code \(code)", comment: "Needs comment")
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case let .httpError(code, url):
            let localizedHTTStatusCodeString = HTTPURLResponse.localizedString(forStatusCode: code)
            return "\(url.absoluteString) \(localizedHTTStatusCodeString)"
        }
    }
    
}

extension HTTPStatusError: CustomNSError {
    
    public static var errorDomain: String {
        return "Rez.HTTPStatusError"
    }
    
    public var errorCode: Int {
        switch self {
        case let .httpError(code, _):
            return code
        }
    }
    
    public var errorUserInfo: [String : Any] {
        switch self {
        case .httpError(_):
            return [:]
        }
    }
    
}
