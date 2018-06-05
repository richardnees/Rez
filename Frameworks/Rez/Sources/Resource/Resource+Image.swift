import Foundation
#if os(OSX)
import AppKit
typealias Image = NSImage
#else
import UIKit
typealias Image = UIImage
#endif

public protocol InitializableFromData {
    init?(data: Data)
}

extension Image: InitializableFromData {
    
}

extension Resource where A: InitializableFromData {
    
    /// Creates a generic Image `Resource` instance from a `URL`.
    ///
    /// - parameter url:                    URL
    /// - parameter allHTTPHeaderFields:    [String : String]
    ///
    /// - returns: The new `Resource` instance.
    public init(url: URL, allHTTPHeaderFields: [String : String]? = nil) {
        self.url = url
        self.allHTTPHeaderFields = allHTTPHeaderFields
        self.parse = { data, response in
            guard let image = A(data: data) else {
                return Result.failure(ParsingError.imageCreationFailed)
            }

            return Result.success(image)
        }
    }
    
}
