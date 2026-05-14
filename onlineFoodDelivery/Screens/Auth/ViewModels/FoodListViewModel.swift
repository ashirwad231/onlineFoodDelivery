//
//  FoodListViewModel.swift
//  onlineFoodDelivery
//
//  Created by Ashirwad on 27/04/26.
//

import Combine
import SwiftUI

class FoodListViewModel: ObservableObject {
        
        private var apiDataSubscriber: AnyCancellable? = nil
        @Published var food: FoodModel? = nil
        
        func hitWebService() {
            apiDataSubscriber = CombineNetworkHelper.fetchFromWebService().sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    guard let url = Bundle.main.url(forResource: "SampleData", withExtension: "json"), let data = try? Data(contentsOf: url) else {
                        fatalError("Failed to load products from bundle")
                    }
                    guard let response = try? JSONDecoder().decode(FoodModel.self, from: data) else { return }
                    self.food = response
                }
            }, receiveValue: { response in
                self.food = response
            })
        }
    }
