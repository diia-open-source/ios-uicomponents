import Foundation

public extension Data {
    /// Get the current directory
    ///
    /// - Returns: the Current directory in NSURL
    fileprivate func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    /// Data into file
    ///
    /// - Parameters:
    ///   - fileName: the Name of the file you want to write
    /// - Returns: Returns the URL where the new file is located in NSURL
    func dataToFile(fileName: String) -> NSURL? {
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
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
