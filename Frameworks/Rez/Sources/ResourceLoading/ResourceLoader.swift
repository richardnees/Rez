import Foundation

public struct ResourceLoader: ResourceLoading {
    public var session: URLSession
    
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    public static var httpErrorCodes: [Int] = {
        var httpErrorCodes: [Int] = []
        
        httpErrorCodes.append(contentsOf: Array(0...99))
        httpErrorCodes.append(contentsOf: Array(400...600))
        
        return httpErrorCodes
    }()
    
    public func load<A>(resource: Resource<A>, completion: @escaping (Result<A>) -> Void) {
        let task = dataTask(resource: resource, completion: completion)
        task.resume()
    }
    
    public func dataTask<A>(resource: Resource<A>, completion: @escaping (Result<A>) -> Void) -> URLSessionDataTask {
        var request = URLRequest(url: resource.url)
        request.allHTTPHeaderFields = resource.allHTTPHeaderFields
        
        let completionHandler = dataTaskCompletionHandler(for: resource, completion: completion)
        return session.dataTask(with: request, completionHandler: completionHandler)
    }
    
    public func dataTaskCompletionHandler<A>(for resource: Resource<A>, completion: @escaping (Result<A>) -> Void) -> (Data?, URLResponse?, Error?) -> Void {
        return { (data, response, error) in
            
            if
                let response = response as? HTTPURLResponse,
                ResourceLoader.httpErrorCodes.contains(where: { $0 == response.statusCode }) {
                completion(Result.failure(HTTPStatusError.httpError(code: response.statusCode, url: resource.url)))
                return
            }
            
            if let error = error {
                if (error as NSError).code != NSURLErrorCancelled {
                    completion(Result.failure(error))
                }
                return
            }
            
            guard let data = data else {
                completion(Result.failure(ParsingError.noData))
                return
            }
            
            let parsedResult = resource.parse(data, response)
            switch parsedResult {
            case let .success(parsedResource):
                completion(Result.success(parsedResource))
            case let .failure(error):
                completion(Result.failure(error))
                break
            }
        }
    }

}
