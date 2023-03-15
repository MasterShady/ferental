//
//  SWLGCloudPageWidget.swift
//  DFToGameLib
//
//  Created by mac on 2023/3/6.
//

import Foundation
import DFBaseLib



class DFSuspendView: UIView {
    
    let myWidth:CGFloat  = 70
    
    let screenBounds = UIScreen.main.bounds
    
    var clickCallBack:(()->())?
    
    var MaxHeight:CGFloat {
        

        return island ? min(screenBounds.width, screenBounds.height) : max(screenBounds.width, screenBounds.height)
    }
    var MaxWidth:CGFloat {
        
        return island ? max(screenBounds.width, screenBounds.height) : min(screenBounds.width, screenBounds.height)
    }
    
    var island:Bool = false
    
   
    var button:UIImageView!
    
    static func suspendView(With:UIView) ->DFSuspendView  {
        
        let view = DFSuspendView.init(frame: .zero)
        
        With.addSubview(view)
        
        view.uiConfigure()
        
        return view
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    
    func uiConfigure()  {
        
        
        island = true
        
        let   min_x = -myWidth/2
        
        frame = CGRect(x: min_x, y: (MaxHeight - myWidth)/2, width: myWidth, height: myWidth)
        
        button = UIImageView.init(image: df_getImage( withName: "suspend_btn"))
        
        button.frame = bounds
        button.isUserInteractionEnabled = true
        button.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(buttonClicked)))
        addSubview(button)
        
        let tapgesture = UIPanGestureRecognizer(target: self, action: #selector(tapEvent(tapGescture: )))
        tapgesture.minimumNumberOfTouches = 1
        isUserInteractionEnabled = true
        
        addGestureRecognizer(tapgesture)
        

        
    }
    

    
    @objc  func buttonClicked()  {
        
        clickCallBack?()
    }
    
    @objc func tapEvent(tapGescture:UIPanGestureRecognizer)  {
        
        switch tapGescture.state {
            
        case .began :
            print("begin")
        case .changed:
//            print("changed")
            
            self.center = tapGescture.location(in: self.superview!)
        case .cancelled:
//            print("canceled")
            fallthrough
        case .ended:
//            print("end")
            
            let endPoint = tapGescture.location(in: self.superview!)
            var adjustCenter:CGPoint = .zero
            if endPoint.y < myWidth/2 {
               
                adjustCenter.y = myWidth/2
            }else if endPoint.y > MaxHeight - myWidth/2 {
                adjustCenter.y = MaxHeight - myWidth/2
            }else{
                adjustCenter.y = endPoint.y
            }
            
            if endPoint.x <= MaxWidth/2 {
                
               
                let   mid_x:CGFloat = 0
                
               
                adjustCenter.x = mid_x
            }else{
                
                let  mid_x:CGFloat = MaxWidth - superview!.safeAreaInsets.right
                
                adjustCenter.x = mid_x
            }
            
            UIView.animate(withDuration: 0.5) {
                
                self.center = adjustCenter
            }
            
        default :
            break;
        }
    }
    

    
}


class DFBackGameView: UIView {
     
    static func backGameView() -> DFBackGameView {
        
        let view = DFBackGameView.init(frame: CGRect.zero)
        
        view.uiConfigure()
        return view
        
    }
    
    var bgView:UIView!
    
    var closeGameBlock:(()->())?
    
    
    func uiConfigure()  {
        
        frame = UIScreen.main.bounds
        
        bgView = UIView.init(frame: CGRect(x: -SCALE_WIDTHS(value: 260), y: 0, width: SCALE_WIDTHS(value: 260), height: frame.height))
        bgView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6000)
        addSubview(bgView)
        let backBtn = UIControl.init(frame: CGRect(x: 0, y: 0, width: SCALE_WIDTHS(value: 200), height: SCALE_WIDTHS(value: 44)))
        
        bgView.addSubview(backBtn)
        
        backBtn.addTarget(self, action: #selector(backBtnClicked), for: .touchUpInside)
        
        let backIcon = UIImageView(image: df_getImage( withName: "back_icon"))
        backIcon.frame = CGRect(x: SCALE_WIDTHS(value: 15), y: SCALE_WIDTHS(value: 15), width: 15, height: 15)
        backBtn.addSubview(backIcon)
        
        let backlabel = UILabel.init(frame: CGRect(x: SCALE_WIDTHS(value: 42), y: SCALE_WIDTHS(value: 12), width: 0, height: 0))
        backlabel.text = "1.4快速游戏"
        backlabel.textColor = .white
        backlabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        backBtn.addSubview(backlabel)
        backlabel.sizeToFit()
        
        let line1 = UIView.init(frame: CGRect(x: SCALE_WIDTHS(value: 15), y: SCALE_WIDTHS(value: 44), width: SCALE_WIDTHS(value: 230), height: 0.5))
        line1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4000)
        bgView.addSubview(line1)
        
        
        let backGameBtn = UIButton.init(type: .custom)
        backGameBtn.setImage(df_getImage( withName: "go_game_btn"), for: .normal)
        backGameBtn.frame.size = CGSize(width: SCALE_WIDTHS(value: 121), height: SCALE_WIDTHS(value: 34))
        backGameBtn.center = CGPoint(x: bgView.frame.width/2, y: center.y + SCALE_WIDTHS(value: 10))
        bgView.addSubview(backGameBtn)
        backGameBtn.addTarget(self, action: #selector(backGameBtnClicked), for: .touchUpInside)
        
        let bottomLabel = UILabel.init(frame: CGRect(x: backGameBtn.frame.minX - SCALE_WIDTHS(value: 11), y: backGameBtn.frame.maxY + SCALE_WIDTHS(value: 12), width: 0, height: 0))
        bottomLabel.text = "点此按钮，退出游戏回到APP"
        bottomLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        bottomLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        bgView.addSubview(bottomLabel)
        bottomLabel.sizeToFit()
        let line2 = UIView.init(frame: CGRect(x: SCALE_WIDTHS(value: 15), y: backGameBtn.frame.maxY + SCALE_WIDTHS(value: 39), width: SCALE_WIDTHS(value: 230), height: 0.5))
        line2.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4000)
        bgView.addSubview(line2)
    }
    
    @objc func backBtnClicked()  {
        
        self.dismiss()
    }
    @objc func backGameBtnClicked()  {
        closeGameBlock?()
        self.dismiss()
    }
    
    func show(with:UIView)  {
         
        with.addSubview(self)
        
        UIView.animate(withDuration: 0.5) {

            self.bgView.frame = CGRect(x: 0, y: 0, width: 260, height: self.frame.height)
        }
    }
    
    func dismiss()  {
        
        self.removeFromSuperview()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard bgView.frame.contains(touches.first!.location(in: self)) == false else{  return}
        
        dismiss()
    }
}
