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

struct SwJson
{
    let filename: String
    
    func data() -> Data? {
        guard let filePath = Bundle.main.path(forResource: filename, ofType: "json") else { return nil }
        let fileUrl = URL(fileURLWithPath: filePath)
        let data = try? Data(contentsOf: fileUrl)
        return data
    }
    
    func n2() {
        guard let path = Bundle.main.path(forResource: "questions", ofType: "json") else {
            return
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let result = try JSONDecoder().decode([RMCharacter].self, from: data)
        } catch {
            print(error)
        }
    }
}

class DwDecoder: JSONDecoder
{
    override init() {
        let frmt2 = DateFormatter()
        frmt2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
        super.init()
        self.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            guard let d = frmt2.date(from: dateStr) else { fatalError() } //fixme some danger here
            return d
        })
    }
}
