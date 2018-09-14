import Foundation

/// Protocol to ensure conformance.
public protocol ResourceLoading {

    /// The URLSession to use.
    var session: URLSession { get set }
    
    /// Creates a `URLSessionDataTask` instance from a generic `Resource` and resumes it immediately.
    ///
    /// - parameter resource:   Generic resource
    /// - parameter completion: The server's response to the request
    func load<A>(resource: Resource<A>, completion: @escaping (Result<A>) -> Void)
    
    /// Creates a `URLSessionDataTask` instance from a generic `Resource`.
    ///
    /// - parameter resource:   Generic resource
    /// - parameter completion: A `Result` with server's response to the request
    ///
    /// - returns: The new `URLSessionDataTaskProtocol` instance.
    func dataTask<A>(resource: Resource<A>, completion: @escaping (Result<A>) -> Void) -> URLSessionDataTask

    /// `URLSessionDataTask` completion handler instance from a generic `Resource`.
    ///
    /// - parameter resource:   Generic resource
    /// - parameter completion: A `Result` with server's response to the request
    ///
    /// - returns: The new `(Data?, URLResponse?, Error?)` closure.
    func dataTaskCompletionHandler<A>(for resource: Resource<A>, completion: @escaping (Result<A>) -> Void) -> (Data?, URLResponse?, Error?) -> Void

}
