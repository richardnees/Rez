//: Playground - noun: a place where people can play

import PlaygroundSupport
import Cocoa
import Rez

PlaygroundPage.current.needsIndefiniteExecution = true

let appURL = URL(string: "https://itunes.apple.com/lookup?id=408709785")!

let resource = Resource<SearchResultsContainer>(url: appURL)

URLSession.shared.load(resource: resource) { result in
    switch result {
    case let .success(container):
        print(container)
    case let .failure(error):
        print(error)
    }
}
