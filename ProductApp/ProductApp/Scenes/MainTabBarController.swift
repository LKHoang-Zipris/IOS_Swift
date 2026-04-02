import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }


    private func setupTabs() {
        let productNav = createNav(
            title: "Product",
            image: "book",
            selectedImage: "book.fill",
            root: ProductListViewController()
        )

        let homeNav = createNav(
            title: "Home",
            image: "house",
            selectedImage: "house.fill",
            root: HomeViewController()
        )

        let profileNav = createNav(
            title: "Profile",
            image: "person",
            selectedImage: "person.fill",
            root: ProfileViewController()
        )

        viewControllers = [productNav, homeNav, profileNav]
        selectedIndex = 2
    }
    

    private func createNav(
        title: String,
        image: String,
        selectedImage: String,
        root: UIViewController
    ) -> UINavigationController {
        let nav = UINavigationController(rootViewController: root)
        nav.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: image),
            selectedImage: UIImage(systemName: selectedImage)
        )
        return nav
    }

    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white

        appearance.stackedLayoutAppearance.selected.iconColor = .systemBlue
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.systemBlue
        ]

        appearance.stackedLayoutAppearance.normal.iconColor = .systemGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.systemGray
        ]

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
