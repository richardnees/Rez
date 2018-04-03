import Cocoa
import Rez

class ViewController: NSViewController {
    
    @IBOutlet weak var idField: NSTextField!
    @IBOutlet weak var lookupButton: NSButton!
    @IBOutlet weak var textView: NSTextView!
    
    @IBAction func lookup(_ sender: NSButton) {
        guard let resource = SearchResultsContainer.lookup(idField.stringValue) else { return }
        
        URLSession.shared.load(resource: resource) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(container):
                    self?.textView.textStorage?.setAttributedString(NSAttributedString(string: String(describing: container)))
                case let .failure(error):
                    let alert = NSAlert(error: error)
                    alert.runModal()
                }
            }
        }
    }
}
