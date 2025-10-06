# PrairieWeather (SwiftUI + MVVM)

A tiny but production-style iOS app that fetches a 7-day forecast for Saskatoon using Open-Meteo.  
Shows Swift + SwiftUI, MVVM, async/await networking, error handling, and simple offline caching.

## Highlights
- SwiftUI UI with MVVM
- Async networking (URLSession + async/await)
- Open-Meteo API (no key)
- Offline cache of last successful response (UserDefaults)
- Pull-to-refresh, toolbar refresh
- Unit test for decoding
- Accessibility labels and Dynamic Type friendly

## How to run
1. Xcode 15+
2. Open the project, run on iOS 17+ simulator

## Talking points in interviews
- Why MVVM and how state flows via `@StateObject` / `@EnvironmentObject`
- Error handling and fallback to offline cache
- API model decoding and mapping to view models
- Extending to geolocation or city search