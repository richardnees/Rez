import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var sessionObserver: NSKeyValueObservation?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        sessionObserver = URLSession.shared.delegateQueue.observe(\.operationCount, options: [.initial, .new]) { session, change in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = URLSession.shared.delegateQueue.operationCount > 0
            }
        }

        return true
    }
}
