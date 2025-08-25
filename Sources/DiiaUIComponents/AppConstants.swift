import UIKit

public struct AppConstants {
    public struct Colors {
        public static let clear = "#0000000"
        public static let black = "#000000"
        public static let white = "#FFFFFF"
        public static let emptyDocuments = "#E2ECF4"
        public static let emptyDocumentsBackground = "#C5D9E9"
        public static let separatorColor = "#CADDEB"
        public static let yellowErrorColor = "#FAEB64"
        public static let sendCopiesSuccess = "#65C680"
        public static let persianRed = "#CA2F28"
        static let imagePlaceholder = "#EFF7FE"
        static let disabledText = "#71767A"
        static let statusGreen = "#19BE6F"
        static let darkGreen = "#008939"
        static let statusYellow = "#FFD600"
        static let statusBlue = "#BED9F5"
        static let vividTangerine = "#FF9975"
        static let dadaGray = "#DADADA"
        static let statusHistoryGray = "#D1D1D1"
        static let downloadButtonBorderColor = "#C9D8E7"

        static let tickerGrayColor = "#ECECEC"
        static let tickerBlueColor = "#E2F2FE"
        static let tickerRedColor = "#D95336"
        public static let uncheckedRoundTabBackgroundColor = "#ECF2F7"
    }
    
    public enum TimeIntervals {
        static let progressAnimationDuration: TimeInterval = 1.5
    }
    
    public enum Layout {
        public static let buttonKeyboardOffset: CGFloat = 8
        public static var buttonBottomOffset: CGFloat = {
            switch UIDevice.size() {
            case .screen4Inch, .screen4_7Inch, .screen5_5Inch: return 32
            default: return 0
            }
        }()
    }
}

public extension UIColor {
    static let blackSqueeze = UIColor("#E2ECF4")
    static let statusGreen = UIColor("#60C864")
    static let statusGray = UIColor("#000000").withAlphaComponent(0.3)
    static let black600 = UIColor("#000000").withAlphaComponent(0.6)
    static let black540 = UIColor("#000000").withAlphaComponent(0.54)
    
    static let statusHistoryGreen = UIColor("#65C680")
    static let statusHistoryGray = UIColor("#D1D1D1")
    static let statusHistoryYellow = UIColor("#FFD600")
    
    static let startGradientColor = UIColor("#E2ECF4").withAlphaComponent(0.0)
    static let endGradientColor = UIColor("#E2ECF4")
    static let emptyDocumentsBackground = UIColor("#C5D9E9")
}
