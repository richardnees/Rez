import Cocoa
import ExampleSupport

class SearchResultsViewController: NSViewController {

    public weak var delegate: SearchResultsSelectionDelegate?
    @IBOutlet weak var tableView: NSTableView!
    
    var results: [SearchResult] = [] {
        didSet {
            tableView.reloadData()
            tableView.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
        }
    }
    
}

extension SearchResultsViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return results.count
    }
    
}

extension SearchResultsViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let searchResultsCellView = tableView.makeView(withIdentifier: SearchResultsCellView.identifier, owner: self) as? SearchResultsCellView
        searchResultsCellView?.textField?.stringValue = results[row].trackName
        return searchResultsCellView
    }
    
    public func tableViewSelectionDidChange(_ notification: Notification) {
        guard let tableView = notification.object as? NSTableView else { return }
        
        let selectionIndexes = tableView.selectedRowIndexes
        
        guard let selectionIndex = selectionIndexes.first else {
            delegate?.viewController(self, didSelect: nil)
            return
        }
        
        let item = results[selectionIndex]
        delegate?.viewController(self, didSelect: item)
    }

}
