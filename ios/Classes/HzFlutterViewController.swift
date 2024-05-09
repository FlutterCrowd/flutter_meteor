//
//  HzFlutterViewController.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/9.
//

import Flutter

class HzFlutterViewController: FlutterViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    deinit {
        print("HzFlutterViewController did deinit")
        HzEngineManager.printCache()
    }

}
