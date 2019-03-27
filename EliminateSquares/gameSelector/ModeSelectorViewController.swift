//
//  ModeSelectorViewController.swift
//  PurificationMonsters
//
//  Created by iOS123 on 2019/3/13.
//  Copyright © 2019年 iOS123. All rights reserved.
//

import UIKit

class ModeSelectorViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //初始不可见
        self.containerView.alpha = 0.1
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //动画淡入
        UIView.animate(withDuration: 0.5) {
            self.containerView.alpha = 1
        }
    }

    @IBAction func back(_ sender: UIButton) {
        Music.shared().musicPlayEffective()
       //退出动画
        UIView.animate(withDuration: 1, animations: {
            self.containerView.alpha = 0.01
            self.containerView.transform = CGAffineTransform.init(rotationAngle: 3)
        }) { (Bool) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    /*页面跳转
     sender.tag == 0 -> Easy
     sender.tag == 1 -> Normal
     sender.tag == 2 -> Random
     */
    @IBAction func selectMode(_ sender: UIButton) {
        //播放音效
        Music.shared().musicPlayEffective()
        //退出动画
        UIView.animate(withDuration: 1, animations: {
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform.init(scaleX: 2.1, y: 2.1)
        }) { (Bool) in
            self.containerView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            if  sender.tag != 2{
                let lsvc = LevelSelectorViewController.init(nibName: nil, bundle: nil)
                lsvc.setTag(tag: sender.tag)
                self.present(lsvc, animated: false, completion: {
                    self.reloadInputViews()
                })
            }else{
                let gvc = GameViewController.init(nibName: nil, bundle: nil)
                gvc.setTag(tag: 2)
                self.present(gvc, animated: false, completion: {
                    self.reloadInputViews()
                })
            }
            
        }
        
    }

}
