import Foundation
import SimpleNetworking

class CityListPageVM {
    
    // MARK: For Displaying Cities
    @Published var cities: [City] = []
    @Published var onCitiesUpdated: (() -> Void)?
    @Published var onError: ((String) -> Void)?
    
    
    
    // MARK: Network Call
    
    private var webService: WebService

    init(webService: WebService = WebService()) {
        self.webService = webService
    }
    
    // For fetching names

    func fetchEuropeanCities(maxRows: String) {
        let urlString = "http://api.geonames.org/searchJSON?formatted=true&continentCode=EU&featureClass=P&maxRows=\(maxRows)&lang=en&username=giorgimm19&style=full"
        
        webService.fetchData(from: urlString, resultType: GeonamesResponse.self) { [weak self] result in
            switch result {
            case .success(let geonamesResponse):
                self?.cities = geonamesResponse.geonames
                self?.fetchImagesForCities()
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
    
    // for fetching images

    private func fetchImagesForCities() {
        let cityNames = cities.map { $0.name }
        let dispatchGroup = DispatchGroup()
        var cityImages: [String: String] = [:]

        for cityName in cityNames {
            dispatchGroup.enter()
            fetchImageForCity(cityName) { result in
                switch result {
                case .success(let imageUrl):
                    cityImages[cityName] = imageUrl
                case .failure(let error):
                    print("Failed to fetch image for \(cityName): \(error)")
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.cities = self.cities.map { city in
                var updatedCity = city
                updatedCity.imageUrl = cityImages[city.name]
                return updatedCity
            }
            self.onCitiesUpdated?()
        }
    }

    private func fetchImageForCity(_ cityName: String, completion: @escaping (Result<String, Error>) -> Void) {
        let urlString = "https://api.unsplash.com/search/photos?query=\(cityName)&client_id=PPpcmxqt_xUnbE3zZ0_m3A8HxbE0oO74SPZVRG82jbE"
        
        webService.fetchData(from: urlString, resultType: UnsplashResponse.self) { result in
            switch result {
            case .success(let unsplashResponse):
                if let firstResult = unsplashResponse.results.first {
                    completion(.success(firstResult.urls.small))
                } else {
                    completion(.failure(NSError(domain: "No image found", code: 0, userInfo: nil)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
