//
//  HTTPClient.swift
//  Last.fm client
//
//  Created by student on 3/25/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation
import SwiftyJSON

enum ContentType {
    case json
    case raw
}

protocol HTTPClient {

    init(baseURL: String)

    func get(parameters: [String: String]?, contentType: ContentType, callback: @escaping (Any?, Error?) -> Void)
    func get(urlAppend: String?, contentType: ContentType, callback: @escaping (Any?, Error?) -> Void)
}

class URLSessionHTTPClient: HTTPClient {

    // MARK: Properties

    private let baseURL: String
    private let defaultSession: URLSession

    required init(baseURL: String) {
        self.baseURL = baseURL
        defaultSession = URLSession(configuration: .default)
    }

    // MARK: Public methods

    func get(parameters: [String: String]? = nil, contentType: ContentType = .json,
             callback: @escaping (Any?, Error?) -> Void) {

        if var urlComponents = URLComponents(string: baseURL) {

            if let currParams = parameters {
                urlComponents.query = currParams.map({$0 + "=" + $1}).joined(separator: "&")
            }

            guard let url = urlComponents.url else {
                fatalError("Unexisting URL")
            }

            let dataTask = defaultSession.dataTask(with: url) { data, _, error in

                guard error == nil else {
                    DispatchQueue.main.async {callback(nil, error)}
                    return
                }

                if var convertibleData = data as Any? {

                    switch contentType {

                    case .json:
                        convertibleData = JSON(convertibleData)

                    case .raw:
                        break
                    }

                    DispatchQueue.main.async {callback(convertibleData, nil)}
                } else {
                    DispatchQueue.main.async {callback(nil, nil)}
                }
            }

            dataTask.resume()
        }

    }
    
    func get(urlAppend: String? = nil, contentType: ContentType = .json,
             callback: @escaping (Any?, Error?) -> Void) {
        
        if let urlComponents = URLComponents(string: baseURL + (urlAppend ?? "")) {
            
            guard let url = urlComponents.url else {
                fatalError("Unexisting URL")
            }
            
            let dataTask = defaultSession.dataTask(with: url) { data, _, error in
                
                guard error == nil else {
                    DispatchQueue.main.async {callback(nil, error)}
                    return
                }
                
                if var convertibleData = data as Any? {
                    
                    switch contentType {
                        
                    case .json:
                        convertibleData = JSON(convertibleData)
                        
                    case .raw:
                        break
                    }
                    
                    DispatchQueue.main.async {callback(convertibleData, nil)}
                } else {
                    DispatchQueue.main.async {callback(nil, nil)}
                }
            }
            
            dataTask.resume()
        }
        
    }
}
