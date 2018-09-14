import Cocoa
import Rez
import RezExampleSupport

class DetailViewController: NSViewController {
    
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var imageLoadingIndicator: NSProgressIndicator!
    @IBOutlet weak var nameField: NSTextField!
    @IBOutlet weak var companyField: NSTextField!
    @IBOutlet weak var priceTextField: NSTextField!
    @IBOutlet weak var priceFormatter: NumberFormatter!
    @IBOutlet weak var categoryTextField: NSTextField!
    @IBOutlet weak var updateTextField: NSTextField!
    @IBOutlet weak var versionTextField: NSTextField!
    @IBOutlet weak var sizeTextField: NSTextField!
    @IBOutlet weak var languagesTextField: NSTextField!

    @IBOutlet weak var descriptionField: NSTextField!
    
    var task: URLSessionDataTask?

    var result: SearchResult? {
        didSet {
            if let result = result {
                nameField.stringValue = result.trackName
                companyField.stringValue = result.artistName
                descriptionField.stringValue = result.description ?? ""
                
                priceTextField.stringValue = result.formattedPrice ?? ""

                categoryTextField.stringValue = result.genres?.first ?? ""
                updateTextField.objectValue = result.currentVersionReleaseDate
                versionTextField.stringValue = result.version ?? ""

                if let fileSizeBytes = result.fileSizeBytes {
                    sizeTextField.integerValue = Int(fileSizeBytes) ?? 0
                }

                if let languageCodesISO2A = result.languageCodesISO2A {
                    languagesTextField.stringValue = languageCodesISO2A
                        .compactMap { Locale.current.localizedString(forLanguageCode: $0) }
                        .joined(separator: ", ")
                }


                imageView.image = nil
                loadImage()
            } else {
                nameField.stringValue = ""
                companyField.stringValue = ""
                descriptionField.stringValue = ""

                priceTextField.stringValue = ""
                categoryTextField.stringValue = ""
                versionTextField.stringValue = ""
                sizeTextField.integerValue = 0
                languagesTextField.stringValue = ""

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
        
        task = ResourceLoader().dataTask(resource: resource) { [weak self] result in
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
