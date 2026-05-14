//
//  ProductDetailScreen.swift
//  onlineFoodDelivery
//
//  Created by Ashirwad on 30/04/26.
//

import SwiftUI


struct ProductDetailScreen: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var food: FoodDetails? = nil
    @State private var quantity: Int = 1
    @ObservedObject var viewModel = ProductDetailViewModel()

    var body: some View {
        ScrollView{
            ZStack {
                VStack{
                    HStack(content: {
                        VStack{
                            if let urlString = food?.strCategoryThumb, !urlString.isEmpty, let url = URL(string: urlString) {
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
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                .background(Circle().fill(Color.gray.opacity(0.2)))
                                .offset(CGSize(width: 0.0, height: 0.0))
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 150, height: 150)
                                    .offset(CGSize(width: 0.0, height: 0.0))
                            }
                            Spacer(minLength: 35)
                            VStack(alignment: .leading) {
                                Text(food?.strCategory?.capitalized ?? "Category")
                                    .font(.headline)
                                Spacer(minLength: 15)
                                Text(food?.strCategoryDescription ?? "Description ")
                                    .font(.subheadline)
                            }.padding(10)
                        }.frame(alignment: .top)
                    })
                }
            }.edgesIgnoringSafeArea(.all)
        }
        HStack(spacing: 10) {
            Stepper(value: $quantity, in: 1...10) {
                Text("\(quantity)")
            }.frame(width: 120,alignment: .trailing)
            Button(action: {
                viewModel.saveFoodDetails(productDetail: food ?? nil, quantity: String(quantity))
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Add to cart")
                    .font(.system(size: 14).weight(.semibold))
                    .foregroundColor(.brown)
            }).frame(alignment: .leading)
        }.frame(alignment: .bottom)
    }
}

#Preview {
    ProductDetailScreen()
}
