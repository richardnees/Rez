import UIKit
import Rez
import ExampleSupport

protocol SearchResultsViewControllerDelegate: class {
    func searchResultsViewController(_ searchResultsViewController: SearchResultsViewController, selected item: SearchResult)
}

class SearchResultsViewController: UITableViewController {

    weak var delegate: SearchResultsViewControllerDelegate?
    var task: URLSessionDataTask?

    var query: String = "" {
        didSet {
            search(query: query)
        }
    }

    var results: [SearchResult] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    func search(query: String) {
        task?.cancel()
        

        guard let resource = SearchResultsContainer.search(query) else { return }
        
        task = URLSession.shared.dataTask(resource: resource) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(container):
                    self?.results = container.results
                case let .failure(error):
                    let alert = UIAlertController(title: "An error occured", message: error.localizedDescription, preferredStyle: .alert)
                    self?.present(alert, animated: true)
                }
            }
        }
        
        task?.resume()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row].trackName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.searchResultsViewController(self, selected: results[indexPath.row])
        dismiss(animated: true)
    }
    
}

extension SearchResultsViewController {
    static func makeViewController() -> SearchResultsViewController? {
        return UIStoryboard(name: "SearchResultsViewController", bundle: nil).instantiateInitialViewController() as? SearchResultsViewController
    }
}


