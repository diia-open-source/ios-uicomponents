import XCTest
@testable import DiiaUIComponents

final class Data_ExtensionsTests: XCTestCase {

    func test_dataToFile_toDocumentsDirectory() {
        let fileName = "somefile.txt"
        
        guard let dataToWrite = "dataToWrite".data(using: .utf8) else {
            XCTFail("data")
            return
        }
        
        let urlOfFile: NSURL? = dataToWrite.save(to: .documents, fileName: fileName)
        XCTAssertNotNil(urlOfFile)
        
        do {
            if let url = urlOfFile {
                try FileManager().removeItem(at: url as URL)
            }
        } catch { log("Error removing the file: \(error.localizedDescription)") }
    }
    
    func test_dataToFile_toTemporaryDirectory() {
        let fileName = "somefile.txt"
        
        guard let dataToWrite = "dataToWrite".data(using: .utf8) else {
            XCTFail("data")
            return
        }
        
        let urlOfFile: NSURL? = dataToWrite.save(to: .temporary, fileName: fileName)
        XCTAssertNotNil(urlOfFile)
        
        do {
            if let url = urlOfFile {
                try FileManager().removeItem(at: url as URL)
            }
        } catch { log("Error removing the file: \(error.localizedDescription)") }
    }
    
    func test_dataToFile_badFileName() {
        let fileName = ""
        let anyDirectory: Data.Directory = .temporary
        
        guard let dataToWrite = "dataToWrite".data(using: .utf8) else {
            XCTFail("data")
            return
        }
        
        let urlOfFile: NSURL? = dataToWrite.save(to: anyDirectory, fileName: fileName)
        
        XCTAssertNil(urlOfFile)
    }
}
