//
//  LevelSelectorViewController.swift
//  PurificationMonsters
//
//  Created by iOS123 on 2019/3/13.
//  Copyright © 2019年 iOS123. All rights reserved.
//

import UIKit

class LevelSelectorViewController: UIViewController,CheckpointButtonProtocol {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var checkpointScrollView: UIScrollView!
    private var checkPointButtons : Array<CheckPointButton> = Array.init()
    /*tag
     0 ==> easy
     1 ==> normal
     2 ==> Freedom
     */
    private var tag = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //初始不可见
        self.containerView.alpha = 0
        
        var titleText = self.titleLabel.text!
        switch self.tag {
        case 0:
            titleText += "\n(easy)"
            break
        case 1:
            titleText += "\n(normal)"
            break
        case 2:
            titleText += "\n(hard)"
            break
        default:
            break
        }
        self.titleLabel.text = titleText
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //动画淡入
        UIView.animate(withDuration: 0.5) {
            self.containerView.alpha = 1
        }
        if self.checkPointButtons.count != 0 {
            //刷新按钮状态
            for item in 0...self.checkPointButtons.count - 1{
                var enable = false
                if item <= UserDefault.getLevel(tag: self.tag){
                    enable = true
                }
                self.checkPointButtons[item].setConfig(title: String(item + 1),enable: enable,type: self.tag)
            }
        }
        
        if self.checkPointButtons.count <= 0 {
            let sc_width = UIScreen.main.bounds.width - 20
            let btn_width : CGFloat = 100 //按钮宽度
            let space : CGFloat = (sc_width - btn_width * 3) / 4 //按钮间距
            let count = (Checkpoints.shared().checkPointsArray[self.tag] as! Array<Any>).count //按钮数量
            //设置scrollview的contentsize
            self.checkpointScrollView.contentSize = CGSize.init(width: self.checkpointScrollView.bounds.width , height: CGFloat((count + 2)/3 ) * (btn_width + space))
            //添加按钮
            for i in 0...count - 1  {
                //初始化按钮
                let x : CGFloat = CGFloat(i % 3) * (btn_width + space) + space
                let y : CGFloat = CGFloat(i / 3) * (btn_width + space) + space
                let checkpoint = CheckPointButton.init(frame: CGRect.init(x: x, y: y, width: btn_width, height: btn_width))
                //设置按钮代理
                checkpoint.delegate = self
                checkpoint.tag = i
                var enable = false
                if i <= UserDefault.getLevel(tag: self.tag){
                    enable = true
                }
                checkpoint.setConfig(title: String(i + 1), enable: enable,type: self.tag)
                self.checkpointScrollView.addSubview(checkpoint)
                self.checkPointButtons.append(checkpoint)
            }
        }
    }
    
    //实现按钮代理协议
    func CheckpointButtonClick(sender: CheckPointButton) {
        self.containerView.layer.zPosition = 1000
        UIView.animate(withDuration: 0.5, animations: {
            self.containerView.layer.transform = CATransform3DRotate(self.containerView.layer.transform, CGFloat(Double.pi), 0, 1, 0)
        }) { (Bool) in
            UIView.animate(withDuration: 0.5,animations:{
                self.containerView.alpha = 0
                self.containerView.layer.transform = CATransform3DRotate(self.containerView.layer.transform, CGFloat(Double.pi), 0, 1, 0)
            }) { (Bool) in
                let gvc = GameViewController.init(nibName: nil, bundle: nil)
                gvc.setTag(tag: self.tag)
                gvc.setLevel(level: sender.tag)
                self.present(gvc, animated: false, completion: nil)
            }
        }
    }

    @IBAction func back(_ sender: UIButton) {
        Music.shared().musicPlayEffective()
        //退出动画
        UIView.animate(withDuration: 1, animations: {
            self.containerView.alpha = 0
            let trans = CGAffineTransform.init(scaleX: 0.0001, y: 0.0001)
            let trans2 = CGAffineTransform.init(rotationAngle: -2.5)
            let t = trans.concatenating(trans2)
            self.containerView.transform = t
        }) { (Bool) in
            self.dismiss(animated: false, completion: nil)
        }
    }

    func setTag(tag:Int) {
        self.tag = tag
    }
}
