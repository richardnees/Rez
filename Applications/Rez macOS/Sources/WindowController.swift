import Cocoa
import ExampleSupport
import Rez

public protocol SearchResultsSelectionDelegate: class {
    func viewController(_ viewController: NSViewController, didSelect result: SearchResult?)
}

class WindowController: NSWindowController {

    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    var resultsViewController: SearchResultsViewController?
    var detailViewController: DetailViewController?
    
    var results: [SearchResult] = [] {
        didSet {
            resultsViewController?.results = results
        }
    }

    override func windowDidLoad() {
        super.windowDidLoad()
    
        guard let window = window else { return }
        
        window.appearance = NSAppearance(named: .vibrantDark)
        window.isMovableByWindowBackground = true
        window.titleVisibility = .hidden
    
        if let splitViewController = contentViewController as? NSSplitViewController {
            splitViewController.childViewControllers.forEach { viewController in
                if let viewController = viewController as? SearchResultsViewController {
                    resultsViewController = viewController
                    resultsViewController?.delegate = self
                } else if let viewController = viewController as? DetailViewController {
                    detailViewController = viewController
                }
            }
        }
    }
    
    func present(error: Error) {
        let alert = NSAlert(error: error)
        if let window = window {
            alert.beginSheetModal(for: window, completionHandler: nil)
        } else {
            alert.runModal()
        }
    }
    
    @IBAction func search(_ sender: NSSearchField) {
        progressIndicator.startAnimation(nil)
                
        guard let resource = SearchResultsContainer.search(sender.stringValue) else { return }
        
        URLSession.shared.load(resource: resource) { [weak self] result in
            DispatchQueue.main.async {
                
                self?.results = []
                self?.progressIndicator.stopAnimation(nil)
                
                switch result {
                case let .success(container):
                    self?.results = container.results
                case let .failure(error):
                    self?.present(error: error)
                }
            }
        }
    }
    
}

extension WindowController: SearchResultsSelectionDelegate {
    
    func viewController(_ viewController: NSViewController, didSelect result: SearchResult?) {
        detailViewController?.result = result
    }
    
}
