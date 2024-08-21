//
//  TabBarViewController.swift
//  Runner
//
//  Created by itbox_djx on 2024/7/24.
//

import UIKit
import flutter_meteor

class TabBarViewController: UITabBarController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.addChild(TestViewController1.init())
//        self.addChild(TestViewController2.init())
        // 创建视图控制器
        let homeVC = createNavController(vc: HomeViewController(), title: "首页", imageName: "home")
        homeVC.fmRouteName = "首页"
        let recommendVC = createNavController(vc: RecommendViewController(), title: "推荐", imageName: "recommend")
        recommendVC.fmRouteName = "推荐"
        let liveVC = createNavController(vc: LiveViewController(), title: "实时", imageName: "live")
        liveVC.fmRouteName = "实时"
        let profileVC = createNavController(vc: ProfileViewController(), title: "我的", imageName: "profile")
        profileVC.fmRouteName = "我的"

        
        // 禁用滑动返回手势但保留返回按钮
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        // 将视图控制器添加到 TabBar
        viewControllers = [homeVC, recommendVC, liveVC, profileVC]
    }

    private func createNavController(vc: UIViewController, title: String, imageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        vc.navigationItem.title = title
        vc.fmRouteName = title
//        vc.hidesBottomBarWhenPushed = true
//        navController.interactivePopGestureRecognizer?.isEnabled = true
        navController.isNavigationBarHidden = true
        return navController
    }
    
    // 实现 UIGestureRecognizerDelegate 方法
    @objc func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
       // 如果当前控制器是根视图控制器，则禁用手势返回
       return true//self.navigationController?.viewControllers.count ?? 0 > 1
   }
    
//    
    
    
    
//    public override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//
//    }
////    
//    public override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//    }
//    
//    public override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
////            reportMemory()
//            print("Memory info: \(report_memory().toJson())")
//        }
//    }
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
