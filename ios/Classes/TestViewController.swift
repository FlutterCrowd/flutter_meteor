//
//  TestViewController.swift
//  Runner
//
//  Created by itbox_djx on 2024/5/6.
//

import Foundation
import UIKit
import Flutter
import hz_router

class TestViewController: UIViewController {

    // 初始化第二个 Flutter 引擎
    let flutterEngine2 = FlutterEngine(name: "engine2", project: nil)
    let flutterEngine3 = FlutterEngine(name: "engine3", project: nil)
    let flutterEngine4 = FlutterEngine(name: "engine4", project: nil)

    // 创建一个按钮属性，以便在视图控制器的其他部分访问它
    let myButton: UIButton = {
        let button = UIButton(type: .system)
        // 设置按钮的标题
        button.setTitle("点击我1", for: .normal)
        // 设置按钮的背景颜色（可选）
        button.backgroundColor = .blue
        // 设置按钮的标题颜色（可选）
        button.setTitleColor(.white, for: .normal)
        // 添加按钮的点击动作
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        // 设置按钮的自动布局约束（这通常在 viewDidLoad 中完成）
        return button
    }()
  
    // 创建一个按钮属性，以便在视图控制器的其他部分访问它
    let myButton2: UIButton = {
        let button = UIButton(type: .system)
        // 设置按钮的标题
        button.setTitle("点击我2", for: .normal)
        // 设置按钮的背景颜色（可选）
        button.backgroundColor = .red
        // 设置按钮的标题颜色（可选）
        button.setTitleColor(.white, for: .normal)
        // 添加按钮的点击动作
        button.addTarget(self, action: #selector(buttonTapped2(_:)), for: .touchUpInside)
        // 设置按钮的自动布局约束（这通常在 viewDidLoad 中完成）
        return button
    }()
    
    
    // 创建一个按钮属性，以便在视图控制器的其他部分访问它
    let myButton3: UIButton = {
        let button = UIButton(type: .system)
        // 设置按钮的标题
        button.setTitle("点击我3", for: .normal)
        // 设置按钮的背景颜色（可选）
        button.backgroundColor = .yellow
        // 设置按钮的标题颜色（可选）
        button.setTitleColor(.white, for: .normal)
        // 添加按钮的点击动作
        button.addTarget(self, action: #selector(buttonTapped3(_:)), for: .touchUpInside)
        // 设置按钮的自动布局约束（这通常在 viewDidLoad 中完成）
        return button
    }()
    
    // 创建一个按钮属性，以便在视图控制器的其他部分访问它
    let myButton4: UIButton = {
        let button = UIButton(type: .system)
        // 设置按钮的标题
        button.setTitle("点击我4", for: .normal)
        // 设置按钮的背景颜色（可选）
        button.backgroundColor = .green
        // 设置按钮的标题颜色（可选）
        button.setTitleColor(.white, for: .normal)
        // 添加按钮的点击动作
        button.addTarget(self, action: #selector(buttonTapped4(_:)), for: .touchUpInside)
        // 设置按钮的自动布局约束（这通常在 viewDidLoad 中完成）
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
          
        // 添加按钮到视图控制器的视图上
        view.addSubview(myButton)
        
        // 设置按钮的布局约束（这里只是一个简单的示例）
        myButton.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            myButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            myButton.widthAnchor.constraint(equalToConstant: 100),
            myButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 设置按钮的布局约束（这里只是一个简单的示例）
        view.addSubview(myButton2)
        myButton2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myButton2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myButton2.topAnchor.constraint(equalTo: myButton.bottomAnchor),
            myButton2.widthAnchor.constraint(equalToConstant: 100),
            myButton2.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(myButton3)
        myButton3.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myButton3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myButton3.topAnchor.constraint(equalTo: myButton2.bottomAnchor),
            myButton3.widthAnchor.constraint(equalToConstant: 100),
            myButton3.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(myButton4)
        myButton4.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myButton4.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myButton4.topAnchor.constraint(equalTo: myButton3.bottomAnchor),
            myButton4.widthAnchor.constraint(equalToConstant: 100),
            myButton4.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
  
    // 按钮点击时调用的方法
    @objc func buttonTapped(_ sender: UIButton) {
        print("1按钮被点击了！")
        let flutterVc: UIViewController = HzEngineManager.createFlutterVC { method, arguments, flutterVc in
            if (method == "pop") {
                HzNavigator.pop(arguments: nil) { arguments in
                    
                }
            } else if (method == "popToRoot") {
                HzNavigator.popToRoot(arguments: Dictionary<String, Any?>.init(), callBack: { arguments in
                    
                })
            }
            return arguments
        }
        HzNavigator.present(toPage: flutterVc, arguments: nil) { arguments in
            
        }
          
    }
    
    // 按钮点击时调用的方法
    @objc func buttonTapped2(_ sender: UIButton) {

        let flutterVc: UIViewController = HzEngineManager.createFlutterVC(entryPoint: "main2") { method, arguments, flutterVc in
            if (method == "pop") {
                HzNavigator.pop(arguments: nil) { arguments in
                    
                }
            } else if (method == "popToRoot") {
                HzNavigator.popToRoot(arguments: Dictionary<String, Any?>.init(), callBack: { arguments in
                    
                })
            }
            return arguments
        } ?? UIViewController()
        HzNavigator.push(toPage: flutterVc, arguments: nil) { arguments in
            
        }
//        self.navigationController?.pushViewController(flutterVc, animated: true)
    }
    
    
    // 按钮点击时调用的方法
    @objc func buttonTapped3(_ sender: UIButton) {
        print("3按钮被点击了！")
        var arg = Dictionary<String, Any>.init()
        arg["1"] = 1
        arg["2"] = "2"
        let flutterVc: UIViewController = HzEngineManager.createFlutterVC(
            entryPoint: "main",
            entrypointArgs: arg,
            initialRoute: "mine") { method, arguments, flutterVc  in
                if (method == "pop") {
                    HzNavigator.pop(arguments: nil) { arguments in
                    }
//                    flutterVc.navigationController?.popViewController(animated: true)
                } else if (method == "popToRoot") {
                    HzNavigator.popToRoot(arguments: nil, callBack: nil)
//                    flutterVc.navigationController?.popViewController(animated: true)
                }else if (method == "pushNamed") {
                    self.buttonTapped2(sender)
                }
            return arguments
        }
        HzNavigator.push(toPage: flutterVc, arguments: nil, callBack: nil)
//        self.navigationController?.pushViewController(flutterVc, animated: true)
    }
    
    // 按钮点击时调用的方法
    @objc func buttonTapped4(_ sender: UIButton) {
        print("4按钮被点击了！")
        var arg = Dictionary<String, Any>.init()
        arg["1"] = 1
        arg["2"] = "2"
        let flutterVc: UIViewController =  HzEngineManager.createFlutterVC(
            entryPoint: "main2",
            entrypointArgs: arg,
            initialRoute: "multi_engin2") { method, arguments, flutterVc in
                
                if (method == "pop") {
                    HzNavigator.pop(arguments: nil) { arguments in
                    }
                }
                if (method == "popToRoot") {
                    HzNavigator.popToRoot(arguments: arguments, callBack: nil)

                }else if (method == "pushNamed") {
                    self.buttonTapped3(sender)
                }
//                flutterVc.dismiss(animated: true)
            return arguments
                
        } ?? UIViewController()
        HzNavigator.push(toPage: flutterVc, arguments: nil, callBack: nil)
//        self.navigationController?.pushViewController(flutterVc, animated: true)
    }
}
