//
//  NetworkTests.swift
//  NetworkTests
//
//  Created by Matt Tian on 2018/4/17.
//  Copyright © 2018 TTSY. All rights reserved.
//

import XCTest

class NetworkTests: XCTestCase {
    
    var expectation: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        
        expectation = XCTestExpectation(description: "networking")
    }
    
    func testNetworkManager() {
        let network = NetworkManager()
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")!
        
        network.loadData(from: url) { result in
            switch result {
            case .success(let data):
                XCTAssertGreaterThan(data.count, 0)
            case .failure:
                XCTFail()
            }
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testNetworkManager2() {
        let session = URLSessionMock()
        let network = NetworkManager2(session: session)
        
        let mockData = Data(bytes: [0, 1, 0, 1])
        session.data = mockData
        
        let url = URL(string: "blank")!
        network.loadData(from: url) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, mockData)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testNetworkManager3() {
        let session = NetworkSessionMock()
        let network = NetworkManager3(session: session)
        
        let mockData = Data(bytes: [0, 1, 0, 1])
        session.data = mockData
        
        let url = URL(string: "blank")!
        network.loadData(from: url) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, mockData)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testReadingFile() {
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: "TestFile", ofType: "txt") else {
            XCTFail()
            return
        }
        
        do {
            let content = try String(contentsOfFile: path, encoding: .utf8)
            XCTAssertEqual(content, "Hello World\n")
        } catch {
            XCTFail()
        }
    }
    
}
