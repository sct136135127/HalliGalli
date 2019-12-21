//
//  HGPopViewController.swift
//  HalliGalli
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 HalliGalli. All rights reserved.
//  游戏规则的弹窗

import UIKit

class HGPopViewController: UIViewController,UIScrollViewDelegate{

    ///弹窗的属性样式
    fileprivate lazy var contentView: UITextView = {
        let object = UITextView()
        object.textColor = UIColor.orange
        object.backgroundColor = UIColor.white
        object.textAlignment = .left
        object.isScrollEnabled = true
        object.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
        //文本视图设置圆角
        object.layer.cornerRadius = 20
        object.layer.masksToBounds = true

        //不允许点击链接和附件
        object.isSelectable = false


        //不允许进行编辑
        object.isEditable = false

        object.font=UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 3))
        object.text = """
        关于游戏：
                 德国心脏病是一款非常火的德式桌上游戏，这款游戏非常考验你的快速反应能力。
        
        游戏规则：
             这款游戏由一幅牌和一个按铃组成，开始先将整幅牌均分给每个人（通常为4人），然后每个人按照顺时针或者逆时针的顺序轮流从自己牌堆的最低下的一张牌由内向外翻出来展示，当玩家看到五或五的倍数个相同的水果时候就可以抢先按下事先放在桌面中心的铃铛，如果按铃时满足抢答的条件，则收回每个人翻出牌牌堆的展示的那一张牌，如果抢答失败，则要给其他每一名玩家一张牌，如果自己牌堆和翻出牌堆都没有牌了，就直接出局，最后剩下的两个人谁的牌数量最多，谁获胜。
        
        关于APP：
             这是一款由南京大学的两名计算机科学与技术系的同学设计开发的APP，目的是在朋友聚会时提供一个方便、有可玩性和线下互动性的游戏方式，没有买德国心脏病的牌不要紧，用这款APP代替牌就行了。
             游戏需要在wifi或者热点环境下进行，玩家通过连接同一个wifi来进行游戏。主界面玩家可以给自己起一个个性化的名字，游戏可以提供给3-6个人玩，玩家需要寻找一个人创建房间，其他人在加入房间界面等待房间列表刷新出现房间，点击后加入即可，之后房主可以看人数变化，玩家都加入后即可开始游戏。
             开发者认为，这款游戏的灵魂在于按铃的这个过程，所以建议玩家一人一台手机，围在一个桌子周围，中间可以放任何一个物体去代替按铃，当然，有按铃会更好。玩家可以左手点击手机左侧的牌堆来翻牌，如果误触左侧的牌堆，可以长按来撤销翻牌；右上角显示的是自己未翻牌的数量和一个虚拟的未翻牌的牌堆；右侧中间显示的是虚拟的按铃，用于抢答。抢答信息最后会由房主来做最终的判断，抢答成功或失败的发牌收牌都会由APP自动完成，只管享受游戏带来的快感吧！
             我们希望看到的游戏流程：大家围在一个小桌周围，桌子中间放着一本书、一支笔或着什么都不放，每个人一台手机，大家左手轻点手机翻牌，右手随时准备抢答，当看到5个西瓜时迅速出手，拍向桌子中心，谁的手在下方谁就抢答成功，然后点击手机中的按铃，房主会弹出消息确认抢答的结果，接着大家可以继续开始紧张的游戏，抢答失败也请按下手机中的按铃哦！
        
        温馨提示：
             游戏失败的方式：1、抢答失败时未翻面牌不够分发给其他人。（没有牌可以翻但还有翻面牌存在的时候还可以抢答嗷！）2、没有剩余牌且翻面的牌都被被人抢走（太菜了只能哭哭惹）
                 若要在热点环境下进行游戏，开放热点的玩家不能作为房间的创建者但可以加入房间！
                 没有桌子的条件下也可以用手机按铃代替抢答，但这样缺少了游戏的灵魂，不推荐！
                 房主需要从游戏开始到最终结束都接收和判断抢答的结果，给房主倒上一杯卡布奇诺！
        """
        return object
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        didFinishInit()
    }
    
//    init() {
//        super.init()
//        self.didFinishInit()
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didFinishInit()
    }
    
    fileprivate func didFinishInit() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .custom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        // contentView.delegate=self
        //contentView.addSubview(contentLabel)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 32, left: 50, bottom: 32, right: 50))
        }
        /*contentLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 32, left: 16, bottom: 32, right: 16))
        }*/
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if !(touches.first?.view?.isDescendant(of: self.contentView) ?? true) {
            dismiss(animated: true, completion: nil)
        }
    }
}
