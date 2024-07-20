import Foundation

class CityMuseumsListPageVM {
    
    
    // MARK: Variables
    var museumNames: [String] = []
    var onDataUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    // MARK: Functions
    
    func fetchMuseums(for cityName: String) {
        let urlString = "https://api.foursquare.com/v3/places/search"
        guard var urlComponents = URLComponents(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let queryItems = [
            URLQueryItem(name: "query", value: "Museum"),
            URLQueryItem(name: "near", value: cityName),
            URLQueryItem(name: "limit", value: "10")
        ]
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            print("Invalid URL components")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "fsq3ZkLaUYdLvYORSX8lktqxVCXVw1aa0SbvB3NMruRYpKQ="
        ]
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                self.onError?(error)
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let results = json["results"] as? [[String: Any]] {
                    self.museumNames = results.compactMap { $0["name"] as? String }
                    DispatchQueue.main.async {
                        self.onDataUpdated?()
                    }
                } else {
                    print("Error parsing JSON")
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
                self.onError?(error)
            }
        }
        
        task.resume()
    }
}
