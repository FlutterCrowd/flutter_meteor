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
        button.setTitle("打开test", for: .normal)
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
        button.setTitle("打开test1", for: .normal)
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
        button.setTitle("打开test2", for: .normal)
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
        button.setTitle("打开flutter", for: .normal)
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
        button.setTitle("返回上一页", for: .normal)
        // 设置按钮的背景颜色（可选）
        button.backgroundColor = .cyan
        // 设置按钮的标题颜色（可选）
        button.setTitleColor(.black, for: .normal)
        // 添加按钮的点击动作
        button.addTarget(self, action: #selector(buttonTapped5(_:)), for: .touchUpInside)
        // 设置按钮的自动布局约束（这通常在 viewDidLoad 中完成）
        return button
    }()
    
    // 创建一个按钮属性，以便在视图控制器的其他部分访问它
    let myButton6: UIButton = {
        let button = UIButton(type: .system)
        // 设置按钮的标题
        button.setTitle("返回到test", for: .normal)
        // 设置按钮的背景颜色（可选）
        button.backgroundColor = .cyan
        // 设置按钮的标题颜色（可选）
        button.setTitleColor(.black, for: .normal)
        // 添加按钮的点击动作
        button.addTarget(self, action: #selector(buttonTapped6(_:)), for: .touchUpInside)
        // 设置按钮的自动布局约束（这通常在 viewDidLoad 中完成）
        return button
    }()
    
    // 创建一个按钮属性，以便在视图控制器的其他部分访问它
    let myButton7: UIButton = {
        let button = UIButton(type: .system)
        // 设置按钮的标题
        button.setTitle("pushAndReplace test1", for: .normal)
        // 设置按钮的背景颜色（可选）
        button.backgroundColor = .cyan
        // 设置按钮的标题颜色（可选）
        button.setTitleColor(.black, for: .normal)
        // 添加按钮的点击动作
        button.addTarget(self, action: #selector(buttonTapped7(_:)), for: .touchUpInside)
        // 设置按钮的自动布局约束（这通常在 viewDidLoad 中完成）
        return button
    }()
    
    // 创建一个按钮属性，以便在视图控制器的其他部分访问它
    let myButton8: UIButton = {
        let button = UIButton(type: .system)
        // 设置按钮的标题
        button.setTitle("pushAndRemoveUntil test2-test1", for: .normal)
        // 设置按钮的背景颜色（可选）
        button.backgroundColor = .cyan
        // 设置按钮的标题颜色（可选）
        button.setTitleColor(.black, for: .normal)
        // 添加按钮的点击动作
        button.addTarget(self, action: #selector(buttonTapped8(_:)), for: .touchUpInside)
        // 设置按钮的自动布局约束（这通常在 viewDidLoad 中完成）
        return button
    }()
    
    // 创建一个按钮属性，以便在视图控制器的其他部分访问它
    let myButton9: UIButton = {
        let button = UIButton(type: .system)
        // 设置按钮的标题
        button.setTitle("返回multi_engin2", for: .normal)
        // 设置按钮的背景颜色（可选）
        button.backgroundColor = .cyan
        // 设置按钮的标题颜色（可选）
        button.setTitleColor(.black, for: .normal)
        // 添加按钮的点击动作
        button.addTarget(self, action: #selector(buttonTapped9(_:)), for: .touchUpInside)
        // 设置按钮的自动布局约束（这通常在 viewDidLoad 中完成）
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "测试-test"
        self.view.backgroundColor = UIColor.white
          

        let buttonWidth = 300.0
        
        view.addSubview(myButton)
        myButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            myButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            myButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 设置按钮的布局约束（这里只是一个简单的示例）
        view.addSubview(myButton2)
        myButton2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myButton2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myButton2.topAnchor.constraint(equalTo: myButton.bottomAnchor, constant: 10),
            myButton2.widthAnchor.constraint(equalToConstant: buttonWidth),
            myButton2.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(myButton3)
        myButton3.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myButton3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myButton3.topAnchor.constraint(equalTo: myButton2.bottomAnchor, constant: 10),
            myButton3.widthAnchor.constraint(equalToConstant: buttonWidth),
            myButton3.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(myButton4)
        myButton4.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myButton4.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myButton4.topAnchor.constraint(equalTo: myButton3.bottomAnchor, constant: 10),
            myButton4.widthAnchor.constraint(equalToConstant: buttonWidth),
            myButton4.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(myButton5)
        myButton5.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myButton5.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myButton5.topAnchor.constraint(equalTo: myButton4.bottomAnchor, constant: 10),
            myButton5.widthAnchor.constraint(equalToConstant: buttonWidth),
            myButton5.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(myButton6)
        myButton6.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myButton6.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myButton6.topAnchor.constraint(equalTo: myButton5.bottomAnchor, constant: 10),
            myButton6.widthAnchor.constraint(equalToConstant: buttonWidth),
            myButton6.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(myButton7)
        myButton7.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myButton7.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myButton7.topAnchor.constraint(equalTo: myButton6.bottomAnchor, constant: 10),
            myButton7.widthAnchor.constraint(equalToConstant: buttonWidth),
            myButton7.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(myButton8)
        myButton8.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myButton8.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myButton8.topAnchor.constraint(equalTo: myButton7.bottomAnchor, constant: 10),
            myButton8.widthAnchor.constraint(equalToConstant: buttonWidth),
            myButton8.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(myButton9)
        myButton9.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myButton9.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myButton9.topAnchor.constraint(equalTo: myButton8.bottomAnchor, constant: 10),
            myButton9.widthAnchor.constraint(equalToConstant: buttonWidth),
            myButton9.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
  
    // 按钮点击时调用的方,
    @objc func buttonTapped(_ sender: UIButton) {
        FMNavigator.push(routeName: "test", options: nil)
    }
    
    // 按钮点击时调用的方法
    @objc func buttonTapped2(_ sender: UIButton) {
        FMNavigator.push(routeName: "test1", options: nil)
    }
    
    // 按钮点击时调用的方法
    @objc func buttonTapped3(_ sender: UIButton) {
        print("test2")
        FMNavigator.push(routeName: "test2", options: nil)
    }
    
    // 按钮点击时调用的方法
    @objc func buttonTapped4(_ sender: UIButton) {
        print("打开新引擎")
        FMNavigator.push(routeName: "multi_engin2", options: nil)
    }
    
    // 按钮点击时调用的方法
    @objc func buttonTapped5(_ sender: UIButton) {
        print("pop")
        FMNavigator.pop(options: nil)
    }
    
    // 按钮点击时调用的方法
    @objc func buttonTapped6(_ sender: UIButton) {
        print("pop until")
        FMNavigator.popUntil(untilRouteName: "test", options: nil)
    }
    
    // 按钮点击时调用的方法
    @objc func buttonTapped7(_ sender: UIButton) {
        print("push and replace")
        FMNavigator.pushToReplacement(routeName: "test1", options: nil)
    }
    
    // 按钮点击时调用的方法
    @objc func buttonTapped8(_ sender: UIButton) {
        print("push and remove until")
        FMNavigator.pushToAndRemoveUntil(routeName: "test2", untilRouteName: "test", options: nil)
    }
    
    // 按钮点击时调用的方法
    @objc func buttonTapped9(_ sender: UIButton) {
        print("push and remove until")
        FMNavigator.popUntil(untilRouteName: "multi_engin2", options: nil)
    }
}
