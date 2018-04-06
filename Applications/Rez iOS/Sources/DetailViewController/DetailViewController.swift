import UIKit
import Rez
import RezExampleSupport

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    
    var task: URLSessionDataTask?
    
    var result: SearchResult? {
        didSet {
            if let result = result {
                nameLabel.text = result.trackName
                companyLabel.text = result.artistName
                imageView.image = nil
                loadImage()
            } else {
                nameLabel.text = ""
                companyLabel.text = ""
                imageView.image = nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        result = nil
        
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = true
        navigationItem.searchController = searchController

        definesPresentationContext = true
    }
    
    func loadImage() {
        task?.cancel()
        
        guard let result = result else { return }
        
        var artworkURL = result.artworkUrl100
        
        if let highResArtworkURL = result.highResArtworkURL {
            artworkURL = highResArtworkURL
        }
        
        let resource = Resource<UIImage>(url: artworkURL)
        
        task = URLSession.shared.dataTask(resource: resource) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(image):
                    self?.imageView.image = image
                case let .failure(error):
                    print(error)
                }
            }
        }
        
        task?.resume()
    }

    // MARK: - Search (Results) Controller
    
    lazy var searchResultsController: SearchResultsViewController = {
        guard let searchResultsController = SearchResultsViewController.makeViewController() else {
            fatalError("We need a SearchResultsViewController")
        }
        searchResultsController.delegate = self
        return searchResultsController
    }()
    
    lazy var searchController: UISearchController = {
        return UISearchController(searchResultsController: searchResultsController)
    }()
    
}

extension DetailViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if
            let query = searchBar.text,
            !query.isEmpty {
            searchResultsController.query = query
        }
    }
    
}

extension DetailViewController: UISearchControllerDelegate {
    
    func didDismissSearchController(_ searchController: UISearchController) {

    }
    
}

extension DetailViewController: SearchResultsViewControllerDelegate {
    
    func searchResultsViewController(_ searchResultsViewController: SearchResultsViewController, selected item: SearchResult) {
        result = item
    }
    
}
