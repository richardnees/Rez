import Foundation

public struct SearchResultsContainer: Codable {
    public let resultCount: Int
    public let results: [SearchResult]
}
