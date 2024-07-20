import Foundation
import SimpleNetworking

class ArtifactsViewModel {
    private let webService = WebService()
    var artifacts: [Item] = []
    var onArtifactsUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    func fetchArtifacts(for museumName: String) {
        guard let encodedMuseumName = museumName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            onError?("Invalid museum name")
            return
        }

        let urlString = "https://api.europeana.eu/record/v2/search.json?wskey=ordroarep&query=\(encodedMuseumName)&qf=TYPE:IMAGE"

        webService.fetchData(from: urlString, resultType: Welcome.self) { [weak self] result in
            switch result {
            case .success(let welcome):
                self?.artifacts = welcome.items.filter { $0.edmIsShownBy?.first != nil }
                self?.onArtifactsUpdated?()
            case .failure(let error):
                switch error {
                case .networkError(let networkError):
                    self?.onError?("Network error: \(networkError.localizedDescription)")
                case .decodingError(let decodingError):
                    print("Decoding error: \(decodingError.localizedDescription)")
                    self?.onError?("Decoding error: \(decodingError.localizedDescription)")
                }
            }
        }
    }

    func fetchImageForAMuseum(_ museumName: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let encodedMuseumName = museumName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "Invalid museum name", code: 0, userInfo: nil)))
            return
        }

        let urlString = "https://api.unsplash.com/search/photos?query=\(encodedMuseumName)&client_id=PPpcmxqt_xUnbE3zZ0_m3A8HxbE0oO74SPZVRG82jbE"

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
