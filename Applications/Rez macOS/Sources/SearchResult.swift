import Foundation

public struct SearchResult: Codable {
    public let advisories: [String]?
    public let appletvScreenshotUrls: [URL]?
    public let artistId: Int
    public let artistName: String
    public let artworkUrl60: URL
    public let artworkUrl100: URL
    public let artworkUrl512: URL
    public let averageUserRating: Double?
    public let averageUserRatingForCurrentVersion: Double?
    public let bundleId: String
    public let contentAdvisoryRating: String
    public let currency: String
    public let currentVersionReleaseDate: Date
    public let description: String
    public let ipadScreenshotUrls: [URL]?
    public let isGameCenterEnabled: Bool?
    public let isVppDeviceBasedLicensingEnabled: Bool
    public let features: [String]?
    // FIXME: fileSizeBytes should be converted to an Int
    public let fileSizeBytes: String
    public let formattedPrice: String
    public let genreIds: [String]
    public let genres: [String]
    public let kind: String
    public let languageCodesISO2A: [String]
    public let minimumOsVersion: String
    public let price: Double
    public let primaryGenreId: Int
    public let primaryGenreName: String
    public let releaseDate: Date
    public let releaseNotes: String
    public let supportedDevices: [String]?
    public let sellerName: String
    public let screenshotUrls: [URL]
    public let trackId: Int
    public let trackName: String
    public let trackCensoredName: String
    public let trackContentRating: String
    public let trackViewUrl: URL
    public let userRatingCount: Int?
    public let userRatingCountForCurrentVersion: Int?
    public let version: String
    public let wrapperType: String
}

extension SearchResult: Equatable {
    public static func ==(lhs: SearchResult, rhs: SearchResult) -> Bool {
        return lhs.trackId == rhs.trackId
    }
}
