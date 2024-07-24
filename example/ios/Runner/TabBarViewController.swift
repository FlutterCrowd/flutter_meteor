//
//  TabBarViewController.swift
//  Runner
//
//  Created by itbox_djx on 2024/7/24.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

      self.addChild(TestViewController1.init())
      self.addChild(TestViewController2.init())
        // 创建视图控制器
        let homeVC = createNavController(vc: HomeViewController(), title: "首页", imageName: "home")
        homeVC.routeName = "首页"
        let recommendVC = createNavController(vc: RecommendViewController(), title: "推荐", imageName: "recommend")
        recommendVC.routeName = "推荐"
        let liveVC = createNavController(vc: LiveViewController(), title: "实时", imageName: "live")
        liveVC.routeName = "实时"
        let profileVC = createNavController(vc: ProfileViewController(), title: "我的", imageName: "profile")
        profileVC.routeName = "我的"

        // 将视图控制器添加到 TabBar
        viewControllers = [homeVC, recommendVC, liveVC, profileVC]
    }

    private func createNavController(vc: UIViewController, title: String, imageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        vc.navigationItem.title = title
        vc.routeName = title
        return navController
    }
}



class HomeViewController: TestViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // 添加其他初始化代码
    }
}

class RecommendViewController: TestViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        // 添加其他初始化代码
    }
}


class LiveViewController: TestViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        // 添加其他初始化代码
    }
}

class ProfileViewController: TestViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        // 添加其他初始化代码
    }
}
