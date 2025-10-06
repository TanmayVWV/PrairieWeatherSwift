import XCTest
@testable import PrairieWeather

final class WeatherServiceTests: XCTestCase {

    func testDecodingSample() throws {
        let json = """
        {
          "daily": {
            "time": ["2025-10-06","2025-10-07"],
            "weathercode": [0, 61],
            "temperature_2m_max": [18.2, 15.1],
            "temperature_2m_min": [7.3, 5.0]
          }
        }
        """.data(using: .utf8)!

        struct API: Decodable {
            let daily: Daily
            struct Daily: Decodable {
                let time: [String]
                let weathercode: [Int]
                let temperature_2m_max: [Double]
                let temperature_2m_min: [Double]
            }
        }

        let api = try JSONDecoder().decode(API.self, from: json)
        XCTAssertEqual(api.daily.time.count, 2)
        XCTAssertEqual(api.daily.weathercode[1], 61)
        XCTAssertEqual(api.daily.temperature_2m_max.first?.rounded(), 18)
    }
}
