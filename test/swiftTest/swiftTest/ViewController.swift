//
//  ViewController.swift
//  swiftTest
//
//  Created by 王雅强 on 2018/3/19.
//  Copyright © 2018年 王雅强. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let v = UIView(frame: CGRect(x: 20, y: 20, width: 50, height: 50));
        v.backgroundColor = UIColor.red;
        self.view.addSubview(v);
//        var sd :Dictionary = ["sdf":"sdf","we":"wer"]
//        var sdf : String = "sdfs\(sd)"
//        var ddf : Optional<Int> = 23
        
        loadjkk { (asd) in
            print(asd)
        }
        
      print()
        
    }

    func loadjkk(blocks a:(_:String)->())  {
        var uibutton = UIButton(type: .contactAdd);
        
        uibutton.addTarget(self, action: "sdfsdf", for: .touchUpInside)
       
        var sddf = Person(name: "asdsdf")
        a(sddf.name)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

