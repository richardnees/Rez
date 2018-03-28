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

extension Resource where A: Decodable {

    /// Creates a generic `Resource` instance from a `URL`.
    ///
    /// - parameter url:                    URL
    /// - parameter allHTTPHeaderFields:    [String : String]
    /// - parameter dataDecodingStrategy:   Data decoding strategy. Defaults to Base64
    /// - parameter dateDecodingStrategy:   Date decoding strategy. Defaults to ISO 8601
    /// - parameter decode:                 Parse function to decode
    ///
    /// - returns: The new `Resource` instance.
    public init(url: URL, allHTTPHeaderFields: [String : String]? = nil, dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .base64, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601) {
        self.url = url
        self.allHTTPHeaderFields = allHTTPHeaderFields
        self.parse = { data, response in
            do {
                let decoder = JSONDecoder()
                decoder.dataDecodingStrategy = dataDecodingStrategy
                decoder.dateDecodingStrategy = dateDecodingStrategy
                let content = try decoder.decode(A.self, from: data)
                return Result.success(content)
            } catch let error {
                return Result.failure(error)
            }
        }
    }
}
