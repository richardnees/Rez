import Foundation

extension Resource where A: Decodable {
    
    /// Creates a generic Decodable `Resource` instance from a `URL`.
    ///
    /// - parameter url:                    URL
    /// - parameter allHTTPHeaderFields:    [String : String]
    /// - parameter dataDecodingStrategy:   Data decoding strategy. Defaults to Base64
    /// - parameter dateDecodingStrategy:   Date decoding strategy. Defaults to ISO 8601
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
