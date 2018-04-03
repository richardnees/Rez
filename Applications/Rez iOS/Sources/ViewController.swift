import UIKit
import Rez

class ViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var lookupBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = lookupBarButtonItem
    }

    @IBAction func lookup(_ sender: UIBarButtonItem) {
        
        guard let id = searchBar.text else {
            textView.text = ""
            return
        }
        
        guard let resource = SearchResultsContainer.lookup(id) else { return }
        
        URLSession.shared.load(resource: resource) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(container):
                    self?.textView.text = String(describing: container)
                case let .failure(error):
                    let alert = UIAlertController(title: "An error occured", message: error.localizedDescription, preferredStyle: .alert)
                    self?.present(alert, animated: true)
                }
            }
        }
    }
}
