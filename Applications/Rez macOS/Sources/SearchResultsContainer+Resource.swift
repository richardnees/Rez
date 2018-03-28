import Foundation
import Rez

extension SearchResultResourceContainer {
    public static func lookup(_ id: String) -> Resource<SearchResultResourceContainer>? {
        
        guard var components = URLComponents(string: "https://itunes.apple.com/lookup") else { return nil }
        
        components.queryItems = [
            URLQueryItem(name: "id", value: id)
        ]
        
        guard let lookupURL = components.url else { return nil }
        
        return Resource<SearchResultResourceContainer>(url: lookupURL)
    }
}
