//
//  FoodListView.swift
//  onlineFoodDelivery
//
//  Created by Ashirwad on 30/04/26.
//

import SwiftUI
import CoreLocation
import Combine

struct FoodListView: View {
    
    @ObservedObject var viewModel : FoodListViewModel
    @State private var apiDataSubscriber: AnyCancellable? = nil
    @State private var locationDataManager = LocationManager()
    @State private var streetAddress = "Food Categories"
    @State private var selectedTab: Int = 0
    
    init(viewModel: FoodListViewModel) {
        self.viewModel = viewModel
    }
    
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
                self.viewModel.food = response
            }
        }, receiveValue: { response in
            self.viewModel.food = response
        })
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerView
                List(viewModel.food?.foodDetails ?? [], id: \.idCategory) { food in
                    NavigationLink(destination: ProductDetailScreen(food: food)) {
                        HStack {
                            if let urlString = food.strCategoryThumb, !urlString.isEmpty, let url = URL(string: urlString) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                    case .failure:
                                        Image(systemName: "photo")
                                            .foregroundColor(.gray)
                                    @unknown default:
                                        Image(systemName: "photo")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .background(Circle().fill(Color.gray.opacity(0.2)))
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 50, height: 50)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(food.strCategory?.capitalized ?? "")
                                    .font(.headline)
                                Text(food.strCategoryDescription ?? "")
                                    .font(.subheadline)
                                    .frame(minWidth: 200)
                            }
                        }
                        .frame(height : 50)
                    }
                }
                .listStyle(PlainListStyle())
            }
            
            VStack {
                Spacer()
                bottomNavigationBar
            }
        }
        .onAppear {
            self.hitWebService()
            if let location = locationDataManager.manager.location {
                CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)) { placemarks, _ in
                    streetAddress = placemarks?.first?.locality ?? "Food Categories"
                }
            } else {
                streetAddress = "Food Categories"
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }

    private var headerView: some View {
        HStack(spacing: 16) {
            NavigationLink(destination: MenuView()) {
                Image(systemName: "line.horizontal.3")
                    .font(.title2)
                    .foregroundColor(.primary)
                    .padding(10)
                    .background(Color.brown.opacity(0.15))
                    .clipShape(Circle())
            }
            
            Text(streetAddress)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .layoutPriority(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)
            
            NavigationLink(destination: CartView(viewModel: ProductDetailViewModel())) {
                Image(systemName: "cart.fill")
                    .font(.title2)
                    .foregroundColor(.primary)
                    .padding(10)
                    .background(Color.brown.opacity(0.15))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
    }
    
    private var bottomNavigationBar: some View {
        HStack(spacing: 0) {
            NavigationLink(destination: FoodListView(viewModel: viewModel)) {
                VStack(spacing: 4) {
                    Image(systemName: "house.fill")
                        .font(.title3)
                    Text("Home")
                        .font(.caption2)
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(selectedTab == 0 ? .brown : .gray)
            }
            .onTapGesture {
                selectedTab = 0
            }
            
            Spacer()
                .frame(width: 1)
                .background(Color.gray.opacity(0.2))
            
            VStack(spacing: 4) {
                Image(systemName: "heart.fill")
                    .font(.title3)
                Text("Favorites")
                    .font(.caption2)
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(selectedTab == 1 ? .brown : .gray)
            .onTapGesture {
                selectedTab = 1
            }
            
            Spacer()
                .frame(width: 1)
                .background(Color.gray.opacity(0.2))
            
            VStack(spacing: 4) {
                Image(systemName: "person.fill")
                    .font(.title3)
                Text("Profile")
                    .font(.caption2)
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(selectedTab == 2 ? .brown : .gray)
            .onTapGesture {
                selectedTab = 2
            }
        }
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .border(Color.gray.opacity(0.2), width: 1)
    }
}
