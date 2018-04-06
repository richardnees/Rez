import Cocoa
import Rez
import RezExampleSupport

class DetailViewController: NSViewController {
    
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var imageLoadingIndicator: NSProgressIndicator!
    @IBOutlet weak var nameField: NSTextField!
    @IBOutlet weak var companyField: NSTextField!

    var task: URLSessionDataTask?

    var result: SearchResult? {
        didSet {
            if let result = result {
                nameField.stringValue = result.trackName
                companyField.stringValue = result.artistName
                imageView.image = nil
                loadImage()
            } else {
                nameField.stringValue = ""
                companyField.stringValue = ""
                imageView.image = nil
            }
        }
    }
    
    func loadImage() {
        task?.cancel()
        imageLoadingIndicator.startAnimation(nil)
        
        guard let result = result else { return }
        
        var artworkURL = result.artworkUrl100
        
        if let highResArtworkURL = result.highResArtworkURL {
            artworkURL = highResArtworkURL
        }
        
        let resource = Resource<NSImage>(url: artworkURL)
        
        task = URLSession.shared.dataTask(resource: resource) { [weak self] result in
            DispatchQueue.main.async {
                
                self?.imageLoadingIndicator.stopAnimation(nil)
                switch result {
                case let .success(image):
                    self?.imageView.image = image
                case let .failure(error):
                    self?.present(error: error)
                }
            }
        }
        
        task?.resume()
    }

    func present(error: Error) {
        let alert = NSAlert(error: error)
        if let window = view.window {
            alert.beginSheetModal(for: window, completionHandler: nil)
        } else {
            alert.runModal()
        }
    }
    
}
