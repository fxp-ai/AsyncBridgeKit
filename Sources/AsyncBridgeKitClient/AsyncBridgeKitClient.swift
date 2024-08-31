import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import AsyncBridgeKit

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}

struct Petitions: Codable {
    var results: [Petition]
}

let session = URLSession.shared
let testURLText = URL(string: "https://fp.ax/test.txt")!
let testURLJSON = URL(string: "https://fp.ax/test.json")!

do {
    let (data, _) = try await session.data(from: testURLText)
    if let fileContent = String(data: data, encoding: .utf8) {
        print(fileContent)
    }
} catch {
    print(error.localizedDescription)
}

do {
    let (json, _) = try await session.data(from: testURLJSON)
    let decoder = JSONDecoder()
    if let petitionsJson = try? decoder.decode(Petitions.self, from: json) {
        let petitions = petitionsJson.results
        for petition in petitions {
            print(petition)
        }
    } else {
        print("Problem with json decoding.")
    }
} catch {
    print(error.localizedDescription)
}

