
import Foundation

public struct UniversalScannerResult: Codable {
    public let scanModalMessageOrg: ScanModalMessageOrgModel?
    public let scanModalCardOrg: ScanModalCardOrg?
    
    public init(scanModalMessageOrg: ScanModalMessageOrgModel? = nil, scanModalCardOrg: ScanModalCardOrg? = nil) {
        self.scanModalMessageOrg = scanModalMessageOrg
        self.scanModalCardOrg = scanModalCardOrg
    }
}
