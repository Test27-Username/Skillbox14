
import Foundation
import CoreData


@objc(CoreDataTask)
public class CoreDataTask: NSManagedObject {

}

extension CoreDataTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataTask> {
        return NSFetchRequest<CoreDataTask>(entityName: "Task")
    }

    @NSManaged public var name: String?

}

class CoreDataInstance: TaskControlDelegate {
    static let shared = CoreDataInstance()
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Skillbox14")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()    
    private var context: NSManagedObjectContext
    
    init() {
        context = persistentContainer.viewContext
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
              context.rollback()
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getTasks() -> [String] {
        var tasks: [String] = []
        
        do {
            let fetchRequest: NSFetchRequest<CoreDataTask> = CoreDataTask.fetchRequest()
            let objects = try context.fetch(fetchRequest)
            
            for task in objects {
                tasks.append(task.name!)
            }
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return tasks
    }
    
    func createTask(_ name: String) {
        let newTask = CoreDataTask(context: context)
        newTask.name = name
        
        saveContext()
    }
    
    func deleteTask(_ index: Int) {
        do {
            let fetchRequest: NSFetchRequest<CoreDataTask> = CoreDataTask.fetchRequest()
            let objects = try context.fetch(fetchRequest)
            
            context.delete(objects[index])
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        saveContext()
    }
}
