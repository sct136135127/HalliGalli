//
//  HGGamingController.swift
//  HalliGalli
//
//  Created by apple on 2019/11/26.
//  Copyright © 2019 HalliGalli. All rights reserved.
//  游戏界面

import UIKit

//MARK:第二阶段

class HGGamingController: UIViewController {
    
    //MARK: 补充注释
    
    ///（撤销）撤销自己翻牌的动画（把左边翻着的牌收回右边牌堆）
    fileprivate func chexiao() {
         UIView.transition(with: self.paidui,duration: 0.25, options: UIView.AnimationOptions.transitionCurlDown, animations: {
                }) { (flag) in
                }
         UIView.transition(with: self.gamingView,duration: 0.5, options: UIView.AnimationOptions.transitionCurlUp, animations: {
            self.gamingView.Show_Card(content: "12304")//MARK: 此处需要更改要显示的牌的数字，显示左边翻着的第二张牌，因为牌顶的被收回去了
         }) { (flag) in
         }
         //self.gamingView.Show_Card(content: <#T##String#>)
         print("撤销翻牌")
     }
    
    
    ///（收牌）本人抢答成功，收牌到牌堆的动画
    fileprivate func shoupai() {
        UIView.transition(with: self.paidui,duration: 0.25, options: UIView.AnimationOptions.transitionCurlDown, animations: {
            //这里可以加一些收牌时的行为
               }) { (flag) in
               }
        UIView.transition(with: self.gamingView,duration: 0.5, options: UIView.AnimationOptions.transitionCurlUp, animations: {
           self.gamingView.Show_Card(content: "12304")//MARK:此处需要更改要显示的牌的数字，显示左边翻着的第二张牌，因为牌顶的被收回去了
        }) { (flag) in
            
        }

        //self.gamingView.Show_Card(content: <#T##String#>)
        print("抢答成功，收牌")
    }
    
    ///（翻牌）玩家自己从牌堆里翻牌
    fileprivate func fanpai() {
        UIView.transition(with: self.paidui,duration: 0.25, options: UIView.AnimationOptions.transitionCurlUp, animations: {
            //这里可以加一些翻牌时的行为
               }) { (flag) in
               }
        UIView.transition(with: self.gamingView,duration: 0.5, options: UIView.AnimationOptions.transitionCurlDown, animations: {
            //这里可以加一些翻牌时的行为
           self.gamingView.Show_Card(content: "12304")//MARK:此处需要更改要显示的牌的数字，显示新的翻出来的牌
        }) { (flag) in
            
        }

        //self.gamingView.Show_Card(content: <#T##String#>)
        print("翻牌成功")
    }
    
    ///（发牌）其他玩家抢答成功，本玩家把左边翻着的牌顶的牌发出去给他
    fileprivate func fapai() {
        UIView.transition(with: self.gamingView,duration: 0.5, options: UIView.AnimationOptions.transitionCurlUp, animations: {
           self.gamingView.Show_Card(content: "12304")//MARK:此处需要显示左边翻着的第二张牌，因为牌顶的被拿走了
        }) { (flag) in
            
        }

        //self.gamingView.Show_Card(content: <#T##String#>)
        print("翻牌成功")
    }
    
    
    ///（发牌2）自己抢答失败，从牌堆里发出去三张牌
    fileprivate func fapai2() {
        UIView.transition(with: self.paidui,duration: 0.5, options: UIView.AnimationOptions.transitionCurlUp, animations: {
            //这里可以写抢答失败后发生的行为，比如剩余牌数-3之类的
        }) { (flag) in
            
        }

        //self.gamingView.Show_Card(content: <#T##String#>)
        print("抢答失败，从牌堆里发出去三张牌")
    }
    
    ///（收牌2）别人抢答失败，本玩家牌堆里收到一张抢答失败的玩家给的牌
        fileprivate func shoupai2() {
        UIView.transition(with: self.paidui,duration: 0.25, options: UIView.AnimationOptions.transitionCurlDown, animations: {
            //这里可以加一些收牌时的行为
               }) { (flag) in
            }

        //self.gamingView.Show_Card(content: <#T##String#>)
        print("别人抢答失败，本人收牌成功")
    }
    
    
    ///长按手势识别
    fileprivate lazy var longPress: UILongPressGestureRecognizer = {
        let object = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(sender:)))
        object.minimumPressDuration = 1
        
        return object
    }()
    
    fileprivate lazy var tapGesture: UITapGestureRecognizer = {
        let object = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        return object
    }()
    
    //MARK: 待完成
    /// 长按事件
    @objc fileprivate func longPressAction(sender: UILongPressGestureRecognizer) {
        if(sender.state == UIGestureRecognizer.State.began ){
            //撤销牌
            
            print("撤销成功")
            //print("Longpress begin")
        }
        else if(sender.state == UIGestureRecognizer.State.ended){
            //这里不变
            //print("Longpress end")
        }
    }
    
    //MARK: 待完成
    /// 点击事件
    @objc fileprivate func tapAction(sender: UITapGestureRecognizer) {
        //请求翻牌
        fanpai()
    }

    /*
    fileprivate lazy var successButton: UIButton = {
        let object = UIButton(type: UIButton.ButtonType.custom)
        object.setTitle("抢答成功", for: UIControl.State.normal);
        object.setTitle("抢答成功", for: UIControl.State.highlighted);
        object.setTitleColor(UIColor.white, for: UIControl.State.normal)
        object.setTitleColor(UIColor.white, for: UIControl.State.highlighted)
        object.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        object.setBackgroundImage(UIImage.imageFromColor(color: kMainThemeColor), for: UIControl.State.normal)
        object.setBackgroundImage(UIImage.imageFromColor(color: kMainThemeColor.withAlphaComponent(0.5)), for: UIControl.State.highlighted)
        object.layer.cornerRadius = 5
        object.layer.masksToBounds = true
        object.addTarget(self, action: #selector(doAction(sender:)), for: UIControl.Event.touchUpInside)
        return object;
    }()
 */
    
    ///抢答按钮设置
    fileprivate lazy var answerButton: UIButton = {
        let object = UIButton(type: UIButton.ButtonType.custom)
//        object.setTitle("抢答失败", for: UIControl.State.normal);
//        object.setTitle("抢答失败", for: UIControl.State.highlighted);
//        object.setTitleColor(UIColor.white, for: UIControl.State.normal)
//        object.setTitleColor(UIColor.white, for: UIControl.State.highlighted)
//        object.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
//        object.setBackgroundImage(UIImage.imageFromColor(color: kMainThemeColor), for: UIControl.State.normal)
//        object.setBackgroundImage(UIImage.imageFromColor(color: kMainThemeColor.withAlphaComponent(0.5)), for: UIControl.State.highlighted)
//        object.layer.cornerRadius = 5
//        object.layer.masksToBounds = true
        object.imageView?.contentMode=UIView.ContentMode.scaleToFill
        object.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.fill;//水平方向拉伸
        object.contentVerticalAlignment = UIControl.ContentVerticalAlignment.fill;//垂直方向拉伸
        object.setImage(UIImage(named: "answer"), for: UIControl.State.normal)
        object.addTarget(self, action: #selector(doAction(sender:)), for: UIControl.Event.touchUpInside)
        return object;
    }()
    
    ///显示剩余牌数的label
    fileprivate lazy var remainingL: UILabel = {
        let object = UILabel()
        object.textAlignment = .center
        object.textColor = UIColor.black
        object.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        return object
    }()
    
    ///显示用户名的label
    fileprivate lazy var userL: UILabel = {
        let object = UILabel()
        object.textAlignment = .center
        object.textColor = UIColor.black
        object.text="\(player.userinfo.ID ?? "")"
        object.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        return object
    }()
    
    ///显示牌堆
    fileprivate lazy var paidui: UIImageView = {
        let object = UIImageView()
        object.layer.cornerRadius = 5
        object.layer.masksToBounds = true
        object.contentMode = UIView.ContentMode.scaleToFill
        object.image=UIImage(named: "paidui")
        object.backgroundColor = UIColor(hex: 0xF7FAFA)
        return object
    }()
    
    ///显示牌的label
    fileprivate lazy var gamingView: HGGamingView = {
        let object = HGGamingView()
        object.layer.cornerRadius = 5
        object.layer.masksToBounds = true
        object.layer.borderWidth=1
        object.layer.borderColor=UIColor.black.cgColor
        object.backgroundColor = UIColor(hex: 0xF7FAFA)
        return object
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //服务器发牌
        server.Arrange_Cards_By_People()
        
        //TImer监听和更新
        
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        StatusBarManager.hideStatusBar()
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(gamingView)
        view.addSubview(remainingL)
        view.addSubview(answerButton)
        view.addSubview(userL)
        view.addSubview(paidui)
        self.gamingView.addGestureRecognizer(self.longPress)
        self.gamingView.addGestureRecognizer(self.tapGesture)
        
        if player.room_num == "6" {
            remainingL.text = "15"
        }else {
            remainingL.text = "16"
        }
        
        gamingView.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(answerButton.snp.left).offset(-10)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
        }
        
        paidui.snp.makeConstraints{(make)in
            make.centerX.equalTo(remainingL)
            make.top.equalTo(remainingL.snp.bottom).offset(2)
            make.size.equalTo(CGSize(width: 80, height: 100))
        }
        remainingL.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.left.equalTo(gamingView.snp.right).offset(20)
            make.right.equalTo(-20)
        }
        
        userL.snp.makeConstraints { (make) in
            make.bottom.equalTo(gamingView).offset(-8)
            make.left.equalTo(gamingView.snp.right).offset(20)
            make.right.equalTo(-20)
        }
        
        answerButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(remainingL)
            make.centerY.equalTo(gamingView.snp.centerY).offset(20)
            make.size.equalTo(CGSize(width: 180, height: 180))
        }
        
        //更新牌封面
        gamingView.Show_Card(content: "00000")
    }
    
    //MARK: 待完成
    //按钮行为
    @objc fileprivate func doAction(sender: UIButton) {
//        if sender ==  successButton {//如果点击抢答成功
//            let controller = UIAlertController(title: "温馨提示", message: "\(userinfo?.Username ?? "你") 抢答成功", preferredStyle: UIAlertController.Style.alert)
//            controller.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action) in //确定抢答成功后的行为（该玩家牌数增加，并要使房间里其他玩家牌减少）
//                self.cardcnt = self.cardcnt! + 1 //实际上应该是加目前桌子上的牌或者从每人那边取一张牌
//                self.remainingL.text = "剩余牌: \(self.cardcnt ?? 0)"
//            }))
//
//            controller.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.destructive, handler: { (action) in
//
//            }))
//            present(controller, animated: true, completion: nil)
//        } else if sender == failureButton {//如果点击抢答失败
//            let controller = UIAlertController(title: "温馨提示", message: "\(userinfo?.Username ?? "你")  抢答失败", preferredStyle: UIAlertController.Style.alert)
//            controller.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action) in //确定抢答失败后的行为
//                self.cardcnt = self.cardcnt! - 1
//                if self.cardcnt ?? 0 <= 0{//如果该玩家没牌了，判断其淘汰，进入淘汰界面
//                    self.roominfo?.count=(self.roominfo?.count)!-1 //房间玩家数减1
//                    self.navigationController?.pushViewController(HGgameoverController(), animated: true)
//                }else{
//                self.remainingL.text = "剩余牌: \(self.cardcnt ?? 0)"
//                }
//            }))
//
//            controller.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.destructive, handler: { (action) in
//
//            }))
//            present(controller, animated: true, completion: nil)
//        }
        if sender == answerButton {
            //按下抢答按钮
        }
    }

    override var canEdgePanBack: Bool {
        return false
    }

}
