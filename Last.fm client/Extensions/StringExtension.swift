//
//  StringExtension.swift
//  Last.fm client
//
//  Created by student on 4/4/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation

extension String {

    func removeHTMLTags() -> String {
        return self.replacingOccurrences(of: "<[^>]+>\\.? *",
                                          with: "\n",
                                          options: .regularExpression,
                                          range: nil)
    }

    func removeStartingNewlineIfExists() -> String {
        return self.replacingOccurrences(of: "^(\\n)",
                                          with: "",
                                          options: .regularExpression,
                                          range: nil)
    }
}
