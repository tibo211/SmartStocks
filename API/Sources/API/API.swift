import Foundation

public enum API {
    private static let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration)
    }()
    
    public static func perform(request: URLRequest, retry: Int) async throws -> (Data, URLResponse) {
        for _ in 0..<retry {
            do {
                return try await session.data(for: request)
            } catch {
                continue
            }
        }
        return try await session.data(for: request)
    }
}
