//
//  MainPageViewModel.swift
//  CultureTrek
//
//  Created by Giorgi Michitashvili on 7/20/24.
//


import Foundation
import SimpleNetworking

class MainPageViewModel: ObservableObject {
    @Published var museums: [GooglePlace] = []
    @Published var errorMessage: String?
    
    private let webService = WebService()
    
    func fetchMuseums() {
        let apiKey = "AIzaSyC2zWn0sqKLXITMzx_TiElnLxFuvkOaICE"
        let query = "museum+in+Europe"
        let urlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(query)&key=\(apiKey)"
        
        webService.fetchData(from: urlString, resultType: GooglePlacesResponse.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.museums = response.results
                case .failure(_): break
                }
            }
        }
    }
    
    private func handleError(_ error: DataFetchError) {
        switch error {
        case .networkError(let networkError):
            errorMessage = "Network error: \(networkError.localizedDescription)"
        case .decodeError(let decodingError):
            errorMessage = "Decoding error: \(decodingError.localizedDescription)"
        }
    }
}
