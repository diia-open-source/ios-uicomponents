import Foundation

public extension String {
    func isValid(regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return isValid(regex: emailRegEx)
    }
    
    var isValidSum: Bool {
        let sumRegEx = "\\d+[.,]?\\d{0,2}"
        return isValid(regex: sumRegEx)
    }
    
    var isValidPhoneNumber: Bool {
        let phoneRegEx = "^(((\\+)|(00))?[0-9]{12}$)|([0-9]{10})"
        return isValid(regex: phoneRegEx)
    }
    
    var isValidUkrainianMobileNumber: Bool {
        let phoneRegEx = "^(\\+)?38(039|050|063|066|067|068|073|091|092|093|094|095|096|097|098|099)\\d{7}$"
        return isValid(regex: phoneRegEx)
    }
    
    func removingPhonePrefix(with possiblePrefixes: [String] = ["38", "+38"]) -> String {
        for phonePrefix in possiblePrefixes {
            if starts(with: phonePrefix) {
                return String(self.dropFirst(phonePrefix.count))
            }
        }
        return self
    }
    
    var isValidPassportNumber: Bool {
        let ukrSymbsRegEx = "^[A-Za-zА-Яа-яЇїІіЄєҐґ0-9`ʼ',-\\\\/()№\\u2019 ]{0,20}"
        return isValid(regex: ukrSymbsRegEx)
    }
    
    var isValidPassportDepartment: Bool {
        let ukrSymbsRegEx = "^[A-Za-zА-Яа-яЇїІіЄєҐґ0-9`ʼ',-\\\\/()№\\u2019 ]{0,150}"
        return isValid(regex: ukrSymbsRegEx)
    }
    
    var isValidName: Bool {
        let ukrSymbsRegEx = "^[ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZабвгґджзклмнпрстфхцчшщйаеєиіїоуюяьАБВГҐДЖЗКЛМНПРСТФХЦЧШЩЙАЕЄИІЇОУЮЯЬЫыЭэЁёъЪ-]+"
        return isValid(regex: ukrSymbsRegEx)
    }
    
    var isValidUkrainianName: Bool {
        let ukrSymbsRegEx = "^[ абвгґджзклмнпрстфхцчшщйаеєиіїоуюяьАБВГҐДЖЗКЛМНПРСТФХЦЧШЩЙАЕЄИІЇОУЮЯЬ-]+"
        return isValid(regex: ukrSymbsRegEx)
    }
    
    var isValidRussianName: Bool {
        let ukrSymbsRegEx = "^[ абвгдеёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ-]+"
        return isValid(regex: ukrSymbsRegEx)
    }
    
    func formattedPhoneNumber(mask: String = "+XX (XXX) XXX XX XX") -> String {
        let cleanPhoneNumber = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    var onlyDigits: String {
        return self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
}
