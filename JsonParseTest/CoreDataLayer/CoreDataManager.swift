//
//  CoreDataManager.swift
//  JsonParseTest
//
//  Created by Pavel Schulepov on 15.11.2022.
//

import CoreData

class CoreDataManager {
    
    func getData() -> [SavePicture] {
        var allPicture = [SavePicture]()
        let coreDataStack = CoreDataStack()
        let context = coreDataStack.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<SavePicture> = SavePicture.fetchRequest()
        
        do {
            allPicture = try context.fetch(fetchRequest)
            print("ExportCoreData DONE")
        } catch {
            print("ExportCoreData ERROR")
        }
        return allPicture
    }
    
    func saveData(id: String, url: String, name: String?, description: String?, date: String?, image: Data?) {
        let coreDataStack = CoreDataStack()
        let context = coreDataStack.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "RecipeData", in: context)
        let object = NSManagedObject(entity: entity!, insertInto: context) as? SavePicture
        object?.idSave = id
        object?.nameSave = name
        object?.descriptionSave = description
        object?.dateSave = date
        object?.urlSave = url
        object?.imageSave = image
        
        do {
            try context.save()
            print("CoreDataSave DONE")
        } catch {
            print("CoreDataSave ERROR")
        }
    }
    
    func deleteData(id: String) {
        var allRecipe = [SavePicture]()
        let coreDataStack = CoreDataStack()
        let context = coreDataStack.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<SavePicture> = SavePicture.fetchRequest()
        
        do {
            allRecipe = try context.fetch(fetchRequest)
            context.delete(search(id: id, allData: allRecipe))
            try context.save()
            print("CoreDataDelete DONE")
        } catch {
            print("CoreDataDelete ERROR")
        }
    }
    
    func search(id: String, allData: [SavePicture]) -> SavePicture {
        return allData.filter({ return String($0.idSave ?? "").lowercased().contains(id.lowercased()) })[0]
    }
    
}