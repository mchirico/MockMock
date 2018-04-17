//
//  Network.swift
//  MockMock
//
//  Created by Matt Tian on 2018/4/17.
//  Copyright © 2018 TTSY. All rights reserved.
//

import Foundation

enum NetworkResult {
    case success(Data)
    case failure(Error?)
}

// No Mock
class NetworkManager {
    
    func loadData(from url: URL, completionHandler: @escaping(NetworkResult) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            let result = data.map(NetworkResult.success) ?? NetworkResult.failure(error)
            completionHandler(result)
        }
        
        task.resume()
    }
    
}

// Partial Mock
class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
}

class URLSessionMock: URLSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    var data: Data?
    var error: Error?
    
    override func dataTask(with url: URL, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
        let data = self.data
        let error = self.error
        
        return URLSessionDataTaskMock {
            completionHandler(data, nil, error)
        }
    }
}

class NetworkManager2 {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func loadData(from url: URL, completionHandler: @escaping(NetworkResult) -> Void) {
        let task = session.dataTask(with: url) { data, _, error in
            let result = data.map(NetworkResult.success) ?? NetworkResult.failure(error)
            completionHandler(result)
        }
        
        task.resume()
    }
}

// Complete Mock

protocol NetworkSession {
    func loadData(from url: URL, completionHandler: @escaping (Data?, Error?) -> Void)
}

extension URLSession: NetworkSession {
    func loadData(from url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
        let task = dataTask(with: url) { (data, _, error) in
            completionHandler(data, error)
        }
        
        task.resume()
    }
}

class NetworkSessionMock: NetworkSession {
    var data: Data?
    var error: Error?
    
    func loadData(from url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
        completionHandler(data, error)
    }
}

class NetworkManager3 {
    private let session: NetworkSession
    
    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }
    
    func loadData(from url: URL, completionHandler: @escaping(NetworkResult) -> Void) {
        session.loadData(from: url) { (data, error) in
            let result = data.map(NetworkResult.success) ?? NetworkResult.failure(error)
            completionHandler(result)
        }
    }
}
