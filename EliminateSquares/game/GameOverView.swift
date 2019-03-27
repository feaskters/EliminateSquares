//
//  GameOverView.swift
//  PurificationMonsters
//
//  Created by iOS123 on 2019/3/14.
//  Copyright © 2019年 iOS123. All rights reserved.
//

import UIKit

protocol GameOverProtocol {
    func gameOverViewTouchsBegan(sender:GameOverView);
}

class GameOverView: UIView {

    let clickLabel = UILabel.init()
    let timeLabel = UILabel.init()
    let titleLabel = UILabel.init()
    var delegate:GameOverProtocol?
    
    lazy var background : UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named:"resultbg"))
        return imageView
    }()
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        //初始化背景
        self.background.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.addSubview(self.background)
        //初始化标题
        if SystemLanguageClass.getCurrentLanguage() == "cn"{
            self.titleLabel.text = "同步完成"
        }else{
            self.titleLabel.text = "CLEAR"
        }
        self.titleLabel.font = UIFont.init(name: "Marker Felt", size: 32)
        self.titleLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.titleLabel.textAlignment = NSTextAlignment.center
        self.titleLabel.frame = CGRect.init(x: self.frame.width / 2 - 75, y: 50, width: 150, height: 100)
        self.addSubview(titleLabel)
        
        //初始化结果
        self.clickLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.clickLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.clickLabel.textAlignment = NSTextAlignment.left
        self.clickLabel.frame = CGRect.init(x: 50, y: 200, width: 100, height: 50)
        self.addSubview(clickLabel)
        
        self.timeLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.timeLabel.textAlignment = NSTextAlignment.left
        self.timeLabel.frame = CGRect.init(x: 50 + self.frame.width/2, y: 200, width: 100, height: 50)
        self.addSubview(timeLabel)
        
        //启动特效
        self.labelEffective()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    //设置结果
    func setResult(result:Dictionary<String,String>) {
        if SystemLanguageClass.getCurrentLanguage() == "cn" {
            self.clickLabel.text = "点击:" + result["click"]!
            self.timeLabel.text = "时间:" + result["time"]!
        }else{
            self.clickLabel.text = "Click:" + result["click"]!
            self.timeLabel.text = "Time:" + result["time"]!
        }
    }
    
    //标题特效设置
    func labelEffective() {
        //标题晃动效果
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (Timer) in
            
            EffectiveClass.rotateAndScale(view: self.titleLabel)
            EffectiveClass.rotateLeft(view: self.clickLabel)
            EffectiveClass.rotateLeft(view: self.timeLabel)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        Music.shared().musicPlayEffective()
        delegate?.gameOverViewTouchsBegan(sender: self)
    }
}
