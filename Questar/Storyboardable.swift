import Foundation
import UIKit

protocol Storyboardable {
    static var storyboardName: String { get }
}

extension Storyboardable where Self: UIViewController {
    
    static var storyboardName: String {
        return String(describing: self)
    }
    
    static func storyboardVC() -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? Self else {
            fatalError("Could not instantiate initial storyboard with name: \(storyboardName)")
        }
        return vc
    }
}

extension UIViewController: Storyboardable { }
