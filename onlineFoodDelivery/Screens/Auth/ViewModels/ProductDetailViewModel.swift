//
//  ProductDetailViewModel.swift
//  onlineFoodDelivery
//
//  Created by Ashirwad on 30/04/26.
//

import Foundation
import CoreData

class ProductDetailViewModel: ObservableObject {
    @Published var foodDetails: [ProductDetail]? = []
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }
    
    func saveFoodDetails(productDetail: FoodDetails?, quantity: String) {
        guard let productDetail = productDetail else { return }
        let newItem = ProductDetail(context: context)
        newItem.category = productDetail.strCategory
        newItem.image = productDetail.strCategoryThumb
        newItem.foodDescription = productDetail.strCategoryDescription
        newItem.quantity = quantity
        do {
            try context.save()
            loadCartItems()
        } catch {
            debugPrint("Failed to save cart item: \(error)")
        }
    }
    
    func getFoodDetail() -> [ProductDetail] {
        let request: NSFetchRequest<ProductDetail> = ProductDetail.fetchRequest()
        do {
            let items = try context.fetch(request)
            foodDetails = items
            return items
        } catch {
            debugPrint("Failed to load cart items: \(error)")
            return []
        }
    }
    
    func loadCartItems() {
        _ = getFoodDetail()
    }
    
    func deleteStoredCart() {
        let request: NSFetchRequest<NSFetchRequestResult> = ProductDetail.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteRequest)
            try context.save()
            foodDetails = []
        } catch {
            debugPrint("Failed to clear cart: \(error)")
        }
    }
}
