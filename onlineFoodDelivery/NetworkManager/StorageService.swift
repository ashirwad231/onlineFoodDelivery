//
//  StorageService.swift
//  onlineFoodDelivery
//
//  Created by Ashirwad on 08/05/26.
//


import CoreData

class StorageService {
    static var viewContext: NSManagedObjectContext {
        DataManager.shared.container.viewContext
    }
    
    static func save() throws {
        try viewContext.save()
    }
    
    static func saveUser(_ email: String, _ password: String) throws {
        let user = User(context: viewContext)
        user.email = email
        user.password = password
        print("💾 Saving user - Email: \(email), Password length: \(password.count)")
        try save()
        print("✅ User saved successfully")
    }
    
    static func getUserBy(_ email: String) throws -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "email == %@", email)
        
        print("🔍 Fetching user with email: \(email)")
        let record = try viewContext.fetch(request)
        print("📋 Found \(record.count) users")
        
        if let user = record.first {
            print("✅ User found - Email: \(user.email ?? "N/A"), Password stored: \(user.password != nil)")
        } else {
            print("❌ User not found with email: \(email)")
        }
        
        return record.first
    }
    
    static func saveProductDetail(productDetail: FoodDetails?, quantity: String) throws {
        let product = ProductDetail(context: viewContext)
        product.quantity = quantity
        product.category = productDetail?.strCategory ?? ""
        product.foodDescription = productDetail?.strCategoryDescription ?? ""
        product.image = productDetail?.strCategoryThumb ?? ""
        try save()
    }
    
    static func getProductDetail() throws -> [ProductDetail] {
        let request: NSFetchRequest<ProductDetail> = ProductDetail.fetchRequest()
        request.returnsObjectsAsFaults = false
        let record = try viewContext.fetch(request)
        return record
    }
    
    static func deleteAllData() throws {
        let fetchRequest: NSFetchRequest<ProductDetail> = ProductDetail.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try viewContext.fetch(fetchRequest)
            for object in results {
                viewContext.delete(object)
            }
        } catch let error {
            print("Detele error :", error)
        }
    }
    
    static func getLoggedinStatus() throws -> Bool{
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = []
        
        let record = try viewContext.fetch(request)
        return ((record.first?.loggedin) != nil)
    }
}
