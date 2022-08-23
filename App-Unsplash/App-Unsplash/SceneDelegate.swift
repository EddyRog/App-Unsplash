//
// SceneDelegate.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import UIKit

protocol Coordinator {
    var navController: UINavigationController { get set }
}

final class AppCoordinator: Coordinator {
    // MARK: - Properties
    internal var navController: UINavigationController
    private let window: UIWindow

    // MARK: - Initializer
    internal init(navController: UINavigationController, window: UIWindow) {
        self.navController = navController
        self.window = window
    }

    func start() {
        window.rootViewController = navController
        window.makeKeyAndVisible()
        showMain()
    }

    // MARK: - Navigation
    private func showMain() {
        guard let searchPhotoViewController = try? SearchPhotosConfigurator(navController: navController).createModule() else { return }
        navController.pushViewController(searchPhotoViewController, animated: true)
        searchPhotoViewController.router?.navigationController = navController
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var app: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let navCon = UINavigationController()
        guard let window = window else { return }

        let appCoodinator = AppCoordinator(navController: navCon, window: window)
        app = appCoodinator
        appCoodinator.start()

//        let searchPhotosConfigurator = SearchPhotosConfigurator()

        // viewcontroller
//        guard let searchPhotosViewController = try? searchPhotosConfigurator.createModule() else { return }
//        let navigationSearchPhotos = UINavigationController(rootViewController: searchPhotosViewController)
////        searchPhotosConfigurator.configureModule(searchPhotosViewController)
//
//        window.rootViewController = navCon
//        window.makeKeyAndVisible()


//        // viewcontroller
//        guard let searchPhotosViewController = try? searchPhotosConfigurator.createModule() else { return }
//        let navigationSearchPhotos = UINavigationController(rootViewController: searchPhotosViewController)
////        searchPhotosConfigurator.configureModule(searchPhotosViewController)

    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

