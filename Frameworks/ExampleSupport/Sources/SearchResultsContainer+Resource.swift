import Foundation
import Rez

extension SearchResultsContainer {
    public static func lookup(_ id: String) -> Resource<SearchResultsContainer>? {
        
        guard var components = URLComponents(string: "https://itunes.apple.com/lookup") else { return nil }
        
        components.queryItems = [
            URLQueryItem(name: "id", value: id)
        ]
        
        guard let url = components.url else { return nil }
        
        return Resource<SearchResultsContainer>(url: url)
    }
    
    public static func search(_ searchString: String) -> Resource<SearchResultsContainer>? {
        
        guard var components = URLComponents(string: "https://itunes.apple.com/search") else { return nil }
        
        let terms = searchString.replacingOccurrences(of: " ", with: "+")
        components.queryItems = [
            URLQueryItem(name: "country", value: "us"),
            URLQueryItem(name: "entity", value: "software"),
            URLQueryItem(name: "term", value: terms)
        ]
        
        guard let url = components.url else { return nil }
        
        return Resource<SearchResultsContainer>(url: url)
    }
}
