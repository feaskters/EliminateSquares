import UIKit

protocol BlockProtocol {
    func BlockViewClicked(sender:BlockView)
}

class BlockView: UIView {
    
    //type == 0-2 -> differentColor
    private var type : Int = 0
    private var position : Dictionary<String,Int>?
    var delegate : BlockProtocol?
    private let background = UIImageView.init(image: UIImage.init(named: "0"))
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.background.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.addSubview(background)
    }

    //更新图片状态
    func updateImage() {
        EffectiveClass.reverse(view: self)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(0.25)) {
            self.background.image = UIImage.init(named: String(self.type))
        }
    }
    
    //设置类型
    func setType(type:Int){
        self.type = type
        updateImage()
    }
    
    //翻转类型
    func reverseType() {
        if self.type == 2 {
            self.type = 0
            EffectiveClass.scaleBigToSmall(view: self)
            UIView.animate(withDuration: 1) {
                self.alpha = 0
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(1)) {
                self.background.image = UIImage.init(named: String(self.type))
            }
        }else if self.type == 0{
            self.type = 2
            self.alpha = 0
            self.background.image = UIImage.init(named: String(self.type))
            UIView.animate(withDuration: 1, animations: {
                self.alpha = 1
                self.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi * 3 / 2) )
            })
        }
    }
    
    //获取类型
    func getType() -> Int{
        return self.type
    }
    
    //设置位置
    func setPosition(x:Int,y:Int) {
        let dic : Dictionary<String,Int> = ["x" : x,
                                            "y" : y]
        self.position = dic
    }
    
    //获取位置
    func getPosition() -> Dictionary<String,Int> {
        return self.position!
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.type == 2 {
            Music.shared().musicPlayMergeEffective()
            delegate?.BlockViewClicked(sender: self)
        }
    }
}
