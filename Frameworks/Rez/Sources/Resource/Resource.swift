import Foundation

/// Generic resource.
public struct Resource<A> {
    public typealias Parser = (Data, URLResponse?) -> Result<A>
    
    /// Request URL
    public let url: URL
    
    /// Optional HTTP header fields
    public let allHTTPHeaderFields: [String : String]?
    
    /// Parse function to decode
    public let parse: Parser
}

extension Resource {
    
    /// Creates a generic `Resource` instance from a `URL`.
    ///
    /// - parameter url:                    URL
    /// - parameter allHTTPHeaderFields:    [String : String]
    /// - parameter decode:                 Parse function to decode
    ///
    /// - returns: The new `Resource` instance.
    public init(url: URL, allHTTPHeaderFields: [String : String]? = nil, decode: @escaping Parser) {
        self.url = url
        self.allHTTPHeaderFields = allHTTPHeaderFields
        self.parse = { data, response in
            return decode(data, response)
        }
    }
    
}
