import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    init() {
        getPosts()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Navigation")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: Operations with posts
    
    var likedPosts: [Post] = []
    
    func getPosts() {
        let request = Post.fetchRequest()
        
        do {
            let likedPosts = try persistentContainer.viewContext.fetch(request)
            self.likedPosts = likedPosts
        } catch {
            print(error.localizedDescription)
        }

    }
    
    func addPost(post: PostBody) {
        let newPost = Post(context: persistentContainer.viewContext)
        newPost.title = post.title
        newPost.image = post.imageName
        newPost.text = post.bodyText
        newPost.likes = post.likes
        newPost.views = post.views
        saveContext()
        getPosts()
    }
    
    func deletePost(post: Post) {
        persistentContainer.viewContext.delete(post)
        saveContext()
        getPosts()
    }
}
