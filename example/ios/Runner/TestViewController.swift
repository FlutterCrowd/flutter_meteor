//
//  TestViewController.swift
//  Runner
//
//  Created by itbox_djx on 2024/5/6.
//

import Foundation
import UIKit
import Flutter
import flutter_meteor

class TestViewController: UIViewController {

    // 初始化第二个 Flutter 引擎
    let flutterEngine2 = FlutterEngine(name: "engine2", project: nil)
    let flutterEngine3 = FlutterEngine(name: "engine3", project: nil)
    let flutterEngine4 = FlutterEngine(name: "engine4", project: nil)

    // 创建一个按钮属性，以便在视图控制器的其他部分访问它
    let myButton: UIButton = {
        let button = UIButton(type: .system)
        // 设置按钮的标题
        button.setTitle("跳原生页面", for: .normal)
        // 设置按钮的背景颜色（可选）
        button.backgroundColor = .blue
        // 设置按钮的标题颜色（可选）
        button.setTitleColor(.black, for: .normal)
        // 添加按钮的点击动作
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        // 设置按钮的自动布局约束（这通常在 viewDidLoad 中完成）
        return button
    }()
  
    // 创建一个按钮属性，以便在视图控制器的其他部分访问它
    let myButton2: UIButton = {
        let button = UIButton(type: .system)
        // 设置按钮的标题
        button.setTitle("打开新引擎", for: .normal)
        // 设置按钮的背景颜色（可选）
        button.backgroundColor = .red
        // 设置按钮的标题颜色（可选）
        button.setTitleColor(.black, for: .normal)
        // 添加按钮的点击动作
        button.addTarget(self, action: #selector(buttonTapped2(_:)), for: .touchUpInside)
        // 设置按钮的自动布局约束（这通常在 viewDidLoad 中完成）
        return button
    }()
    
    
    // 创建一个按钮属性，以便在视图控制器的其他部分访问它
    let myButton3: UIButton = {
        let button = UIButton(type: .system)
        // 设置按钮的标题
        button.setTitle("返回上个页面", for: .normal)
        // 设置按钮的背景颜色（可选）
        button.backgroundColor = .yellow
        // 设置按钮的标题颜色（可选）
        button.setTitleColor(.black, for: .normal)
        // 添加按钮的点击动作
        button.addTarget(self, action: #selector(buttonTapped3(_:)), for: .touchUpInside)
        // 设置按钮的自动布局约束（这通常在 viewDidLoad 中完成）
        return button
    }()
    
    // 创建一个按钮属性，以便在视图控制器的其他部分访问它
    let myButton4: UIButton = {
        let button = UIButton(type: .system)
        // 设置按钮的标题
        button.setTitle("发送多引擎消息", for: .normal)
        // 设置按钮的背景颜色（可选）
        button.backgroundColor = .green
        // 设置按钮的标题颜色（可选）
        button.setTitleColor(.black, for: .normal)
        // 添加按钮的点击动作
        button.addTarget(self, action: #selector(buttonTapped4(_:)), for: .touchUpInside)
        // 设置按钮的自动布局约束（这通常在 viewDidLoad 中完成）
        return button
    }()
    
    // 创建一个按钮属性，以便在视图控制器的其他部分访问它
    let myButton5: UIButton = {
        let button = UIButton(type: .system)
        // 设置按钮的标题
        button.setTitle("发送多引擎消息", for: .normal)
        // 设置按钮的背景颜色（可选）
        button.backgroundColor = .cyan
        // 设置按钮的标题颜色（可选）
        button.setTitleColor(.black, for: .normal)
        // 添加按钮的点击动作
        button.addTarget(self, action: #selector(buttonTapped5(_:)), for: .touchUpInside)
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
        
        view.addSubview(myButton5)
        myButton5.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myButton5.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myButton5.topAnchor.constraint(equalTo: myButton4.bottomAnchor),
            myButton5.widthAnchor.constraint(equalToConstant: 100),
            myButton5.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
  
    // 按钮点击时调用的方法
    @objc func buttonTapped(_ sender: UIButton) {
        FMNativeNavigator.push(toPage: TestViewController.init())
    }
    
    // 按钮点击时调用的方法
    @objc func buttonTapped2(_ sender: UIButton) {
        FMNavigator.push(routeName: "test", options: nil)
    }
    
    // 按钮点击时调用的方法
    @objc func buttonTapped3(_ sender: UIButton) {
        print("3按钮被点击了！")
        FMNavigator.pop(options: nil)
    }
    
    // 按钮点击时调用的方法
    @objc func buttonTapped4(_ sender: UIButton) {
        print("4按钮被点击了！")
//        FlutterMeteor.sendEvent(eventName: "native_event", arguments: Dictionary<String, Any>.init()) { result in
            
//        }
    }
    
    // 按钮点击时调用的方法
    @objc func buttonTapped5(_ sender: UIButton) {
        print("4按钮被点击了！")
//        FlutterMeteor.sendEvent(eventName: "native_event1", arguments: Dictionary<String, Any>.init()) { result in
            
//        }
    }
}
