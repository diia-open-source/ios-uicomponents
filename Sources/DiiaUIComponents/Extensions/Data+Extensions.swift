
import Foundation

public extension Data {
    enum Directory {
        case documents
        case temporary
        
        fileprivate var searchPathDirectory: FileManager.SearchPathDirectory {
            switch self {
            case .documents:
                return .documentDirectory
            case .temporary:
                return .cachesDirectory
            }
        }
    }
    
    /// Get path to selected directory
    ///
    /// - Returns: the Selected directory NSURL as NSString
    fileprivate func getPath(for directory: Directory) -> NSString? {
        let paths = NSSearchPathForDirectoriesInDomains(directory.searchPathDirectory, .userDomainMask, true)
        return paths.first as? NSString
    }
    
    /// Data into file
    ///
    /// - Parameters:
    ///   - directory: the Directory of the file you want to write
    ///   - fileName: the Name of the file you want to write
    /// - Returns: Returns the URL where the new file is located in NSURL
    func save(to directory: Directory, fileName: String) -> NSURL? {
        guard let filePath = getPath(for: directory)?.appendingPathComponent(fileName) else { return nil }
        return dataToFile(fileURL: URL(fileURLWithPath: filePath))
    }
    
    // TODO: Remove after merge "Weapon permit" in to develop
    func dataToFile(fileName: String) -> NSURL? {
        guard let filePath = getPath(for: .documents)?.appendingPathComponent(fileName) else { return nil }
        return dataToFile(fileURL: URL(fileURLWithPath: filePath))
    }
    
    func dataToFile(fileURL: URL) -> NSURL? {
        let data = self
        do {
            try data.write(to: fileURL)
            return NSURL(fileURLWithPath: fileURL.path)
        } catch {
            log("Error writing the file: \(error.localizedDescription)")
        }

        return nil
    }
}
