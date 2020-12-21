
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
    @NSManaged public var isCompleted: Bool

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
    
    func getTasks() -> [Task] {
        var tasks: [Task] = []
        
        do {
            let fetchRequest: NSFetchRequest<CoreDataTask> = CoreDataTask.fetchRequest()
            let objects = try context.fetch(fetchRequest)
            
            for item in objects {
                let task = Task()
                task.name = item.name
                task.isCompleted = item.isCompleted
                tasks.append(task)
            }
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return tasks
    }
    
    func createTask(task: Task) {
        let newTask = CoreDataTask(context: context)
        newTask.name = task.name
        
        saveContext()
    }
    
    func updateTask(index: Int, task: Task) {
        do {
            let fetchRequest: NSFetchRequest<CoreDataTask> = CoreDataTask.fetchRequest()
            let objects = try context.fetch(fetchRequest)
            
            let updatedTask = objects[index]
            updatedTask.name = task.name
            updatedTask.isCompleted = task.isCompleted
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        saveContext()
    }
    
    func deleteTask(index: Int) {
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
