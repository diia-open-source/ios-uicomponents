import XCTest
@testable import DiiaUIComponents

final class Data_ExtensionsTests: XCTestCase {

    func test_dataToFile() {
        let fileName = "somefile.txt"
        
        guard let dataToWrite = "dataToWrite".data(using: .utf8) else {
            XCTFail("data")
            return
        }
        
        let urlOfFile: NSURL? = dataToWrite.dataToFile(fileName: fileName)
        XCTAssertNotNil(urlOfFile)
        
        do {
            if let url = urlOfFile {
                try FileManager().removeItem(at: url as URL)
            }
        } catch { log("Error removing the file: \(error.localizedDescription)") }
    }
    
    func test_dataToFile_badFileName() {
        let fileName = ""
        
        guard let dataToWrite = "dataToWrite".data(using: .utf8) else {
            XCTFail("data")
            return
        }
        
        let urlOfFile: NSURL? = dataToWrite.dataToFile(fileName: fileName)
        
        XCTAssertNil(urlOfFile)
    }
}
