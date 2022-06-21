//
//  ForecastListViewModel.swift
//  WeatherApp
//
//  Created by Erik Kokinda on 21/06/2022.
//

import CoreLocation
import Foundation
import SwiftUI

class ForecastListViewModel: ObservableObject {
    @Published var forecasts: [ForecastViewModel] = []
    @AppStorage("location") var location: String = ""
    @AppStorage("system")var system: Int = 0 {
        didSet {
            for i in 0..<forecasts.count {
                forecasts[i].system = system
            }
        }
    }
    
    init() {
        if location != "" {
            getWeatherForecast()
        }
        
    }
    
    
    func getWeatherForecast() {
        let apiService = APIService.shared
        
        CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let lat = placemarks?.first?.location?.coordinate.latitude,
               let lon = placemarks?.first?.location?.coordinate.longitude
            {
            apiService.getJSON(urlString: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely,hourly&units=metric&appid=678dd1f7ce03ba9f6ed9804d363bb4ef", dateDecodingStrategy: .secondsSince1970)
            { (result: Result<Forecast,APIService.APIError>) in
                switch result {
                case .success(let forecast):
                    DispatchQueue.main.async {
                        self.forecasts = forecast.daily.map { ForecastViewModel(forecast: $0, system: self.system)}
                    }
                case .failure(let apiError):
                    switch apiError {
                    case .error(let errorString):
                        print(errorString)
                    }
                }
            }
            }
        }

    }
}
