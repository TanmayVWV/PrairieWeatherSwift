import Foundation

protocol WeatherServicing {
    func fetchSaskatoonForecast() async throws -> ForecastBundle
}

struct WeatherService: WeatherServicing {
    // Saskatoon coords
    private let lat = 52.1332
    private let lon = -106.6700

    func fetchSaskatoonForecast() async throws -> ForecastBundle {
        // Open-Meteo: daily tmax/tmin + weathercode, timezone=auto
        var comps = URLComponents(string: "https://api.open-meteo.com/v1/forecast")!
        comps.queryItems = [
            .init(name: "latitude", value: "\(lat)"),
            .init(name: "longitude", value: "\(lon)"),
            .init(name: "daily", value: "weathercode,temperature_2m_max,temperature_2m_min"),
            .init(name: "timezone", value: "auto")
        ]
        let (data, resp) = try await URLSession.shared.data(from: comps.url!)
        guard let http = resp as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        // Decode a tiny schema we care about
        struct API: Decodable {
            let daily: Daily
            struct Daily: Decodable {
                let time: [String]
                let weathercode: [Int]
                let temperature_2m_max: [Double]
                let temperature_2m_min: [Double]
            }
        }

        let api = try JSONDecoder().decode(API.self, from: data)
        let df = DateFormatter(); df.dateFormat = "yyyy-MM-dd"; df.timeZone = .current

        var days: [DailyForecast] = []
        for i in 0..<api.daily.time.count {
            guard
                i < api.daily.weathercode.count,
                i < api.daily.temperature_2m_max.count,
                i < api.daily.temperature_2m_min.count,
                let date = df.date(from: api.daily.time[i])
            else { continue }

            days.append(DailyForecast(
                date: date,
                maxTemp: api.daily.temperature_2m_max[i],
                minTemp: api.daily.temperature_2m_min[i],
                weatherCode: api.daily.weathercode[i]
            ))
        }

        return ForecastBundle(city: "Saskatoon", fetchedAt: Date(), days: days)
    }
}
