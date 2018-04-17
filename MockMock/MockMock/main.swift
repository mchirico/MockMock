//
//  main.swift
//  MockMock
//
//  Created by Matt Tian on 2018/4/17.
//  Copyright © 2018 TTSY. All rights reserved.
//

import Foundation

print("Hello, World!")

let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")!
let network = NetworkManager()
print("Start networking")

network.loadData(from: url) { result in
    switch result {
    case .success(let data):
        print("Got data: \(data.count)")
    case .failure(let error):
        print("Got error: \(error?.localizedDescription ?? "No Error")")
    }
    print("Complete network")
    exit(0)
}

RunLoop.current.run()
