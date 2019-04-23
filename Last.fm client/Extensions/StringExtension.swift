//
//  StringExtension.swift
//  Last.fm client
//
//  Created by student on 4/4/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

extension String {

    func repalceHTMLTags(with replaceStr: String) -> String {
        return self.replacingOccurrences(of: "<[^>]+>\\.? *",
                                          with: replaceStr,
                                          options: .regularExpression,
                                          range: nil)
    }

    func removeStartingNewlineIfExists() -> String {
        return self.replacingOccurrences(of: "^(\\n)*",
                                          with: "",
                                          options: .regularExpression,
                                          range: nil)
    }
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
}

extension String: Storable {
    
    var mainInfo: String {
        return self
    }

    var topInfo: String? {
        return nil
    }

    var bottomInfo: String? {
        return nil
    }

    var imageURLs: [ImageSize: String]? {
        return nil
    }
    
    var rating: Int16? {
        get{
            return nil
        }
        set{}
    }
    
    var isFavorite: Bool? {
        get{
            return nil
        }
    }
    
    func getAddidtionalInfo(closure: @escaping (AdditionalInfo) -> ()) {
        let additional = AdditionalInfo()
        closure(additional)
    }
    
    func addToFavorite() {
        return
    }
    func removeFromFavorite() {
        return
    }
}
