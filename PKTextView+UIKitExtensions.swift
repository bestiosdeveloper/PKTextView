//
//  PKTextView.swift
//  PKTextView
//
//  Created by Pramod Kumar on 11/05/16.
//  Copyright © 2016 Pramod Kumar. All rights reserved.
//

import UIKit

//MARK:- String Extension
//extension String{
//
//    var asUrl: URL? {
//        if self.hasPrefix("http://") || self.hasPrefix("https://") {
//            return URL(string: self)
//        }
//        else {
//            return URL(fileURLWithPath: self)
//        }
//    }
//
//    var isImageUrl: Bool {
//
//        let imageExtensions = ["png", "jpg", "gif"]
//        // Iterate & match the URL objects from your checking results
//        let pathExtention = URL(fileURLWithPath: self).pathExtension
//        return imageExtensions.contains(pathExtention)
//    }
//
//    var boolValue: Bool {
//        if (self.lowercased() == "true") || (self.lowercased() == "1") || (self.lowercased() == "yes") {
//            return true
//        }
//        else {
//            return false
//        }
//    }
//
//    var localized: String{
//        return NSLocalizedString(self, comment: "")
//    }
//
//    var intValue: Int {
//        return (self as NSString).integerValue
//    }
//
//    var longIntValue: Int64 {
//        return (self as NSString).longLongValue
//    }
//
//    func stringByRemovingLeadingTrailingWhitespaces() -> String {
//        let spaceSet = CharacterSet.whitespaces
//        return self.trimmingCharacters(in: spaceSet)
//    }
//    var trimmedValue: String {
//        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//    }
//
//    var firstCharacter: Character {
//        guard self.count > 0 else {
//            return Character(" ")
//        }
//        return self[self.index(self.startIndex, offsetBy: 0)]
//    }
//
//    var lastCharacter: Character {
//        if self.count <= 0 {
//            return Character(" ")
//        }
//        return self[self.index(self.endIndex, offsetBy: -1)]
//    }
//
//    var firstWord: String {
//        if self.count <= 0 {
//            return ""
//        }
//        return self.split(by: " ").first ?? ""
//    }
//
//    var lastWord: String {
//        if self.count <= 0 {
//            return ""
//        }
//        return self.split(by: " ").last ?? ""
//    }
//
//    var decodedString: String {
//        let jsonString = (self as NSString).utf8String
//        if jsonString == nil{
//            return self
//        }
//
//        let jsonData: Data = Data(bytes: UnsafeRawPointer(jsonString!), count: Int(strlen(jsonString)))
//        if let goodMessage = NSString(data: jsonData, encoding: String.Encoding.nonLossyASCII.rawValue){
//            return goodMessage as String
//        }else{
//            return self
//        }
//    }
//
//    var encodedString: String {
//        let uniText: NSString = NSString(utf8String: (self as NSString).utf8String!)!
//        let msgData: Data = uniText.data(using: String.Encoding.nonLossyASCII.rawValue)!
//        let goodMsg: NSString = NSString(data: msgData, encoding: String.Encoding.utf8.rawValue)!
//        return goodMsg as String
//    }
//
//    func removePrefix(_ count: Int = 1) -> String {
//        guard self.count > 0 else {
//            return ""
//        }
//        return String(self[self.index(self.startIndex, offsetBy: count)...]) //subString from Index
//    }
//
//    func removeSuffix(_ count: Int = 1) -> String {
//        guard self.count > 0 else {
//            return ""
//        }
//        return String(self[..<self.index(self.endIndex, offsetBy: -count)]) //subString to Index
//    }
//
//    func modify(subStrings: [String], withFont font: UIFont, withColor color: UIColor = UIColor.black) -> NSMutableAttributedString {
//
//        let attributedString = NSMutableAttributedString(string: self)
//
//        for str in subStrings {
//            let range = (self as NSString).range(of: str)
//            attributedString.setAttributes([NSAttributedStringKey.font : font, NSAttributedStringKey.foregroundColor : color], range: range)
//        }
//        return attributedString
//    }
//
//    func sizeCount(withFont font: UIFont, bundingSize size: CGSize, forLines lines: Int = 0) -> CGSize {
//
//        if lines > 0 {
//            let height = font.lineHeight * CGFloat(lines)
//            return CGSize(width: size.width, height: height)
//        }
//        else {
//            let mutableParagraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
//            mutableParagraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
//            let attributes: [NSAttributedStringKey : AnyObject] = [NSAttributedStringKey.font: font, NSAttributedStringKey.paragraphStyle: mutableParagraphStyle]
//            let tempStr = NSString(string: self)
//
//            let rect: CGRect = tempStr.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
//            let height = ceilf(Float(rect.size.height))
//            let width = ceilf(Float(rect.size.width))
//            return CGSize(width: CGFloat(width), height: CGFloat(height))
//        }
//    }
//
//    func getDate(withAbbreviation abbreviation: String = "UTC", formate: String = "yyyy-MM-dd HH:mm:ss a") -> Date{
//        let inDateFormatter: DateFormatter = DateFormatter()
//        inDateFormatter.dateFormat = formate
//        inDateFormatter.timeZone = TimeZone(abbreviation: abbreviation)
//        let inDate: Date = inDateFormatter.date(from: self)!
//        let outDateFormatter: DateFormatter = DateFormatter()
//        outDateFormatter.timeZone = TimeZone.autoupdatingCurrent
//        outDateFormatter.dateFormat = formate
//        let outDateStr: Date = outDateFormatter.date(from: outDateFormatter.string(from: inDate))!
//        return outDateStr
//    }
//
//    func getSubscriptedAttributedString(_ usedFont: UIFont, subscriptedText: String, fontColor: UIColor = UIColor.black) -> NSMutableAttributedString {
//        let attributedAddressStr = NSMutableAttributedString(string : self, attributes: [NSAttributedStringKey.font : usedFont, NSAttributedStringKey.foregroundColor: fontColor])
//        return attributedAddressStr
//    }
//
//    func allWords(startWith: String) -> [String] {
//        var tags = [String]()
//        let stringWithTags : NSString  = self as NSString
//        let regex: NSRegularExpression = try! NSRegularExpression(pattern: "[\(startWith)](\\w+)", options: NSRegularExpression.Options.caseInsensitive)
//
//        let matches: [NSTextCheckingResult] = regex.matches(in: stringWithTags as String, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, stringWithTags.length))
//
//        let nsString = NSString(string: self)
//
//        for match in matches {
//            let wordRange: NSRange = match.range(at: 0)
//            let wordText = nsString.substring(with: wordRange)
//            tags.append(String(wordText))
//        }
//        return tags
//    }
//
//    func heighLightHashTags(hashTagsFont: UIFont, hashTagsColor: UIColor) -> NSMutableAttributedString{
//
//        let stringWithTags : NSString  = self as NSString
//        let regex: NSRegularExpression = try! NSRegularExpression(pattern: "[#](\\w+)", options: NSRegularExpression.Options.caseInsensitive)
//
//        let matches: [NSTextCheckingResult] = regex.matches(in: stringWithTags as String, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, stringWithTags.length))
//        let attString: NSMutableAttributedString = NSMutableAttributedString(string: self, attributes: [NSAttributedStringKey.font: hashTagsFont])
//        for match: NSTextCheckingResult in matches {
//            let wordRange: NSRange = match.range(at: 0)
//            //Set Font
//            attString.addAttribute(NSAttributedStringKey.font, value: hashTagsFont, range: NSMakeRange(0, stringWithTags.length))
//            //Set Foreground Color
//            attString.addAttribute(NSAttributedStringKey.foregroundColor, value: hashTagsColor, range: wordRange)
//        }
//        return attString
//    }
//
//    func indexOf(sub: String) -> Int? {
//        var pos: Int?
//        if let range = self.range(of: sub) {
//            if !range.isEmpty {
//                pos = self.distance(from: self.startIndex, to: range.lowerBound)
//            }
//        }
//        return pos
//    }
//
//    mutating func firstLetterCapital(eachWord:Bool = true)->String{
//
//        let arr = self.split(by: " ")
//        var arrUpdated = [String]()
//        if eachWord && arr.count > 1{
//            for var item in arr {
//                item = item.firstLetterCapital(eachWord:false)
//                arrUpdated.append(item)
//            }
//            return arrUpdated.joined(separator: " ")
//        }
//        else{
//            if self.count == 1{
//                self = self.uppercased()
//            }
//            else{
//                let firstChar = String(self[..<self.index(after: self.startIndex)]) //to index
//                self = firstChar.uppercased() + String(self[self.index(after: self.startIndex)...]) //from index
//            }
//            return self
//        }
//    }
//
//    func split(by: String) -> [String] {
//        let arr = self.components(separatedBy: by).filter { (newVal) -> Bool in
//            return newVal.count > 0
//        }
//        return arr
//    }
//}


//MARK:- UIView Extension
//extension UIView {
//    func addShadowWith(_ shadowOffset: CGSize = CGSize(width: 0, height: 0), shadowRadius:CGFloat = 10.0, shadowOpacity: Float = 0.8, color: UIColor = UIColor.black) {
//        self.layer.masksToBounds = false
//        self.layer.shadowOffset = shadowOffset
//        self.layer.shadowRadius = shadowRadius
//        self.layer.shadowOpacity = shadowOpacity
//        self.layer.shadowColor = color.cgColor
//    }
//}

