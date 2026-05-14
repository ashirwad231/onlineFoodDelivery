//
//  WebServices.swift
//  onlineFoodDelivery
//
//  Created by Ashirwad on 27/04/26.
//

import Foundation
import Combine

enum WebServiceError: Error, LocalizedError {
    case unknown, customError(reason: String)
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .customError(reason: let reason):
            return reason
        }
    }
}

class CombineNetworkHelper {
    
    static func fetchFromWebService() -> AnyPublisher<FoodModel, WebServiceError> {
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php")!
        let urlRequest = URLRequest(url: url)
        
        var dataPublisher: AnyPublisher<FoodModel, WebServiceError>
        dataPublisher = URLSession.DataTaskPublisher(request: urlRequest, session: .shared)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw WebServiceError.unknown
                }
                return data
            }
            .decode(type: FoodModel.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .mapError { error in
                if let error = error as? WebServiceError {
                    return error
                } else {
                    return WebServiceError.customError(reason: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
        return dataPublisher
    }
}
