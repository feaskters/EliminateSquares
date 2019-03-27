//
//  GameViewController.swift
//  PurificationMonsters
//
//  Created by iOS123 on 2019/3/13.
//  Copyright © 2019年 iOS123. All rights reserved.
//

import UIKit

class GameViewController: UIViewController,GameOverProtocol,BlockProtocol {

    @IBOutlet weak var clickCount: UILabel!
    @IBOutlet weak var timeCount: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    /*
     tag == 0 -> Easy
     tag == 1 -> normal
     tag == 2 -> random
     */
    private var tag = 0;
    private var level = 0;
    private var blocksArray : Array<Array<BlockView>> = Array<Array<BlockView>>.init()
    private var length = 9;
    private var autotimer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //设置标题
        switch self.tag {
        case 0:
            self.titleLabel.text = "Easy " + String(self.level + 1)
            break
        case 1:
            self.titleLabel.text = "Normal " + String(self.level + 1)
            break
        case 2:
            self.titleLabel.text = "Freedom"
            break
        default:
            break
        }
        //适配ipad
        if UIScreen.main.bounds.width < 400 {
            //gameview适配
            self.gameView.frame = CGRect.init(x: self.gameView.frame.origin.x + 30, y: self.gameView.frame.width, width: 370, height: 370)
        }
        self.addBlocks()
        //开始计时
        self.autotimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
            self.timeCount.text = String(Int(self.timeCount.text!)! + 1)
        }
    }
    /*
     0 -> 空
     1 -> 墙壁
     2 -> 方块
     3 -> 随机*/
    //页面方块初始化
    func addBlocks() {
        //适配ipad
        if UIScreen.main.bounds.width <= 400 {
            self.gameView.frame = CGRect.init(x: 10, y: self.gameView.frame.origin.y, width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.width - 20)
        }
        let scSquare : CGFloat = self.gameView.frame.width
        let blockSquare : CGFloat = scSquare / CGFloat(self.length)
        
        let levelArray = ((Checkpoints.shared().checkPointsArray[self.tag] as! Array<Any>)[self.level] as! Dictionary<String,Any>)["blocks"]! as! Array<Array<Int>>
        
        for i in 0...Int(self.length) - 1 {
            self.blocksArray.append([])
            for j in 0...Int(self.length) - 1{
                let block = BlockView.init(frame: CGRect.init(x: CGFloat(j) * blockSquare, y: CGFloat(i) * blockSquare, width: blockSquare, height: blockSquare))
                block.setPosition(x: j, y: i)
                block.setType(type: levelArray[i][j] != 3 ? levelArray[i][j] : Int(arc4random() % 2) * 2)
                block.delegate = self
                self.blocksArray[i].append(block)
                self.gameView.addSubview(block)
            }
        }
    }
    
    
    @IBAction func back(_ sender: UIButton) {
        Music.shared().musicPlayEffective()
        //退出动画
//        UIView.animate(withDuration: 1, animations: {
//            self.containerView.alpha = 0
//            let trans = CGAffineTransform.init(scaleX: 0.0001, y: 0.0001)
//            let trans2 = CGAffineTransform.init(rotationAngle: -2.5)
//            let t = trans.concatenating(trans2)
//            self.containerView.transform = t
//        }) { (Bool) in
//            self.dismiss(animated: false, completion: nil)
//        }
        EffectiveClass.reversePage(view: self.containerView)
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(1)) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func setTag(tag:Int) {
        self.tag = tag
    }
    func setLevel(level:Int ) {
        self.level = level
    }
    
    //判断结束
    func judgeEnd() {
        var flag = true
        for items in self.blocksArray{
            for item in items{
                if item.getType() == 2{
                    flag = false
                }
            }
        }
        if flag{
            self.gameOver()
        }
    }
    
    //弹出结算页面
    func gameOver() {
        self.autotimer?.invalidate()
        UserDefault.setLevel(level: self.level + 1, tag: self.tag)
        let gov = GameOverView.init(frame: CGRect.init(x: 0, y: -300, width: self.containerView.frame.width, height: 300))
        let result = ["click" : self.clickCount.text!,
                      "time" : self.timeCount.text!]
        gov.setResult(result: result)
        gov.delegate = self
        self.view.addSubview(gov)
        UIView.animate(withDuration: 0.2) {
            gov.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height / 2 - 150, width: self.containerView.frame.width, height: 300)
        }
    }
    
    //代理方法，游戏结束点击事件
    func gameOverViewTouchsBegan(sender:GameOverView) {
        self.back(UIButton.init())
        UIView.animate(withDuration: 0.2) {
            sender.frame = CGRect.init(x: 0, y: -300, width: self.containerView.frame.width, height: 300)
        }
    }
    
    //代理方法，点击事件
    func BlockViewClicked(sender: BlockView) {
        self.clickCount.text = String(Int(self.clickCount.text!)! + 1)
        let postition = sender.getPosition()
        let x : Int = postition["x"]!
        let y : Int = postition["y"]!
        //上
        if self.blocksArray[y - 1][x].getType() == 1{
            EffectiveClass.scale(view: self.blocksArray[y - 1][x])
        }else{
            self.blocksArray[y - 1][x].reverseType()
        }
        //左
        if self.blocksArray[y][x - 1].getType() == 1{
            EffectiveClass.scale(view: self.blocksArray[y][x - 1])
        }else{
            self.blocksArray[y][x - 1].reverseType()
        }
        //下
        if self.blocksArray[y + 1][x].getType() == 1{
            EffectiveClass.scale(view: self.blocksArray[y + 1][x])
        }else{
            self.blocksArray[y + 1][x].reverseType()
        }
        //右
        if self.blocksArray[y][x + 1].getType() == 1{
            EffectiveClass.scale(view: self.blocksArray[y][x + 1])
        }else{
            self.blocksArray[y][x + 1].reverseType()
        }
        //自身
        sender.reverseType()
        self.judgeEnd()
    }
}
