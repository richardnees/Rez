//: [Previous](@previous)

import Foundation
import Rez

Array(0...600).forEach { number in
    print("-----------------------------------")

    let error = HTTPStatusError.httpError(code: number, url: URL(string: "https://www.apple.com")!)
    print(error.localizedDescription)

    if let recoverySuggetion = error.recoverySuggestion {
        print(recoverySuggetion)
    }
    
}

//: [Next](@next)
