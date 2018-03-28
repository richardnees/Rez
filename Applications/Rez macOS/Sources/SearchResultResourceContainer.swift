import Foundation

public struct SearchResultResourceContainer: Codable {
    public let resultCount: Int
    public let results: [SearchResult]
}

