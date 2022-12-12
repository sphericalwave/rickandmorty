//
//  SwData.swift
//  OAuthTests
//
//  Created by Aaron Anthony on 2021-10-21.
//

import Foundation

struct SwData {
    
    let data: Data
    
    func prettyPrint() {
        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        let d = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let s = String(data: d, encoding: .utf8)!
        print(s)
    }
}
