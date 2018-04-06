//: Playground - noun: a place where people can play

import PlaygroundSupport
import Cocoa
import Rez
import RezExampleSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let resource = SearchResultsContainer.search("apple")!

URLSession.shared.load(resource: resource) { result in
    switch result {
    case let .success(container):
        
        container.results.forEach { result in
            print(result.trackName)
        }
        
    case let .failure(error):
        print(error)
    }
}
