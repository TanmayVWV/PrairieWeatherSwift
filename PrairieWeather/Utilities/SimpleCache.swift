import Foundation

enum SimpleCache {
    private static let key = "cached_forecast"

    static func save(_ data: Data) {
        UserDefaults.standard.set(data, forKey: key)
    }

    static func load() -> Data? {
        UserDefaults.standard.data(forKey: key)
    }
}
