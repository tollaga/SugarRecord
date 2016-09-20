import Foundation
import CoreData

public extension CoreData {

    public enum ObjectModel {
        case Named(String, Bundle)
        case Merged([Bundle]?)
        case URL(NSURL)
        
        func model() -> NSManagedObjectModel? {
            switch self {
            case .Merged(let bundles):
                return NSManagedObjectModel.mergedModel(from: bundles)
            case .Named(let name, let bundle):
                return NSManagedObjectModel(contentsOf: bundle.url(forResource: name, withExtension: "momd")!)
            case .URL(let url):
                return NSManagedObjectModel(contentsOf: url as URL)
            }
            
        }
        
    }
}


// MARK: - ObjectModel Extension (CustomStringConvertible)

extension CoreData.ObjectModel: CustomStringConvertible {
    public var description: String {
        get {
            switch self {
            case .Named(let name): return "NSManagedObject model named: \(name) in the main NSBundle"
            case .Merged(_): return "Merged NSManagedObjec models in the provided bundles"
            case .URL(let url): return "NSManagedObject model in the URL: \(url)"
            }
        }
    }
}


// MARK: - ObjectModel Extension (Equatable)

extension CoreData.ObjectModel: Equatable {}

public func == (lhs: CoreData.ObjectModel, rhs: CoreData.ObjectModel) -> Bool {
    return lhs.model() == rhs.model()
}
