import Foundation

// Generic `Result` enum with *success* and *failure*
public enum Result<A> {
    case success(A)
    case failure(Error)
}
