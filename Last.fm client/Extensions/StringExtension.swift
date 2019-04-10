//
//  StringExtension.swift
//  Last.fm client
//
//  Created by student on 4/4/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation

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

    var aboutInfo: String? {
        return nil
    }

    var imageURLs: [ImageSize: String]? {
        return nil
    }

}
