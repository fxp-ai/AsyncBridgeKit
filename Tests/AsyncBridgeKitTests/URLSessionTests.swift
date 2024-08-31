import XCTest
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@testable import AsyncBridgeKit


final class URLSessionTests: XCTestCase {
    private let session = URLSession.shared
    private let fileContents = "Hello, world!"
    private let validURL = URL(string: "https://fp.ax")!
    private let invalidURL = URL(string: "https://vp.ml")!

    func testDataFromURLWithoutError() async throws {
        let testFile = validURL.appendingPathComponent("test.txt")
        let (data, response) = try await session.data(from: testFile)
        let string = String(data: data, encoding: .utf8)
        XCTAssertEqual(string, fileContents)
        XCTAssertEqual(response.url, testFile)
    }

    func testDataFromURLThatThrowsError() async {
        do {
            _ = try await session.data(from: invalidURL)
            XCTFail("Exceptected error to be thrown.")
        } catch {
            verifyThatError(error, containsURL: invalidURL)
        }
    }

}

private extension URLSessionTests {
    func verifyThatError(_ error: Error, containsURL url: URL) {
        XCTAssertTrue("\(error.localizedDescription)".contains(url.host!))
    }
}