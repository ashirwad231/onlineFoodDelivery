//
//  CartView.swift
//  onlineFoodDelivery
//
//  Created by Ashirwad on 30/04/26.
//
import SwiftUI

struct CartView: View {
    @ObservedObject var viewModel = ProductDetailViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    init(viewModel: ProductDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            if let items = viewModel.foodDetails, !items.isEmpty {
                List(items, id: \.category) { food in
                    HStack(spacing: 16) {
                        if let urlString = food.image, !urlString.isEmpty, let url = URL(string: urlString) {
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
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .background(Circle().fill(Color.gray.opacity(0.2)))
                        } else {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 80, height: 80)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(food.category ?? "Unknown")
                                .fontWeight(.semibold)
                            Text(food.quantity ?? "")
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
                .listStyle(PlainListStyle())
            } else {
                Spacer()
                Text("Your cart is empty")
                    .foregroundColor(.secondary)
                    .font(.headline)
                Spacer()
            }
        }
        .onAppear {
            viewModel.foodDetails = viewModel.getFoodDetail()
        }
        .navigationBarTitle("Cart", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("<Back")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.deleteStoredCart()
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Clear Cart")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

//
//#Preview {
//    CartView()
//}
