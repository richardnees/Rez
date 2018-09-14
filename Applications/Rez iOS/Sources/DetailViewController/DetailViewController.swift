import UIKit
import Rez
import RezExampleSupport

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var languagesLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!

    var task: URLSessionDataTask?
    
    var result: SearchResult? {
        didSet {
            if let result = result {
                nameLabel.text = result.trackName
                companyLabel.text = result.artistName
                
                descriptionLabel.text = result.description ?? ""
                
//                priceLabel.text = result.formattedPrice ?? ""
//
//                categoryLabel.text = result.genres?.first ?? ""
//
//                let dateFomatter = DateFormatter()
//                updateLabel.text = dateFomatter.string(from: result.currentVersionReleaseDate ?? Date(timeIntervalSince1970: 0))
//
//                versionLabel.text = result.version ?? ""
//
//                if let fileSizeBytes = result.fileSizeBytes {
//                    let sizeFormatter = NumberFormatter()
//                    sizeLabel.text = sizeFormatter.string(from: NSNumber(value: Int(fileSizeBytes) ?? 0))
//                }
//
//                if let languageCodesISO2A = result.languageCodesISO2A {
//                    languagesLabel.text = languageCodesISO2A
//                        .compactMap { Locale.current.localizedString(forLanguageCode: $0) }
//                        .joined(separator: ", ")
//                }

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
        
        task = ResourceLoader().dataTask(resource: resource) { [weak self] result in
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
