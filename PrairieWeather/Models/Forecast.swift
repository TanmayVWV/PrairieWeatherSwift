import Foundation

struct DailyForecast: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let maxTemp: Double
    let minTemp: Double
    let weatherCode: Int
}

struct ForecastBundle: Codable {
    let city: String
    let fetchedAt: Date
    let days: [DailyForecast]
}
