//
//  CoreDataManager.swift
//  VeroDigitalTaskAPP
//
//  Created by Musa Adıtepe on 12.02.2025.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData store failed to load: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveTasks(_ tasks: [Task]) {
        context.performAndWait {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TaskEntity.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
                
                tasks.forEach { task in
                    let taskEntity = TaskEntity(context: context)
                    taskEntity.task = task.task
                    taskEntity.title = task.title
                    taskEntity.taskDescription = task.description
                    taskEntity.colorCode = task.colorCode
                }
                
                try context.save()
            } catch {
                print("Error saving tasks: \(error)")
            }
        }
    }
    
    func fetchTasks() -> [Task] {
        var tasks: [Task] = []
        context.performAndWait {
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            
            do {
                let taskEntities = try context.fetch(fetchRequest)
                tasks = taskEntities.map { entity in
                    Task(task: entity.task,
                         title: entity.title,
                         description: entity.taskDescription,
                         colorCode: entity.colorCode)
                }
            } catch {
                print("Error fetching tasks: \(error)")
            }
        }
        return tasks
    }
}
