//
//  DFPlatformShareUtil.swift
//  lolmTool
//
//  Created by mac on 2022/5/27.
//

import Foundation
import UIKit

struct DFFreePlayShareModel : HandyJSON {
    var text: String?
    var image: String?
    var url: String!
    var title: String!
    var platform: Int = 0
    var localImage:UIImage?
}


struct DFPlatformShareUtil {
    
    
    
     
   static func free_shareTask(with:DFFreePlayShareModel)  {
        let shareParam = NSMutableDictionary()
       
       if let imageString = with.image {
           shareParam.ssdkSetupShareParams(byText: with.text, images: imageString, url: .init(string: with.url)!, title: with.title, type: SSDKContentType.auto)
       }else if let image = with.localImage{
           shareParam.ssdkSetupShareParams(byText: with.text, images: image, url: .init(string: with.url)!, title: with.title, type: SSDKContentType.auto)
       }
        
        var platfom:SSDKPlatformType
        var PlatformName:String
        switch with.platform {
        case 1:
            platfom = .subTypeWechatTimeline
            PlatformName = "微信"
        case 2:
            platfom = .subTypeQQFriend
            PlatformName = "QQ"
        case 3:
            platfom = .subTypeQZone
            PlatformName = "QQ"
        default:
            platfom = .subTypeWechatSession
            PlatformName = "微信"
        }
        
        ShareSDK.share(platfom, parameters: shareParam) { state, resDic, entity, error in
            if state == .success {
                AutoProgressHUD.showAutoHud( "分享成功")
            }
            
            if state == .fail {
                let err:NSError = error! as NSError
                
                if err.code == 200105 || err.code == 200104 {
                    AutoProgressHUD.showAutoHud( "未检测到\(PlatformName),请确认是否已经安装")
                }else{
                    AutoProgressHUD.showAutoHud( err.description)
                }
            }
        }
        
    }
    
    //分享单张图
    static func free_shareImageTask(image:UIImage,platform:Int)  {

        let shareParam = NSMutableDictionary.init()
    shareParam.ssdkSetupShareParams(byText: "", images: image, url: nil, title: "", type: SSDKContentType.auto)
        
        var platfom:SSDKPlatformType
        var PlatformName:String
        switch platform {
        case 1:
            platfom = .subTypeWechatTimeline
            PlatformName = "微信"
        case 2:
            platfom = .subTypeQQFriend
            PlatformName = "QQ"
        case 3:
            platfom = .subTypeQZone
            PlatformName = "QQ"
        default:
            platfom = .subTypeWechatSession
            PlatformName = "微信"
        }
        
        ShareSDK.share(platfom, parameters: shareParam) { state, resDic, entity, error in
            if state == .success {
                AutoProgressHUD.showAutoHud( "分享成功")
            }
            
            if state == .fail {
                let err:NSError = error! as NSError
                
                if err.code == 200105 || err.code == 200104 {
                    AutoProgressHUD.showAutoHud( "未检测到\(PlatformName),请确认是否已经安装")
                }else{
                    AutoProgressHUD.showAutoHud( err.description)
                }
            }
        }
        
    }
}

class DFPlatformShareWidget: UIView {
      
    var contentView: UIView

    override init(frame: CGRect) {
        
        contentView = UIView.init(frame: CGRect.zero)
        
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(_ animate: Bool) {
            
        self.superview?.layoutIfNeeded()
         
        UIView.animate(withDuration: TimeInterval(0.25)) {
           
            self.backgroundColor = .white
            
            self.contentView.snp.updateConstraints { (make) in
                
                make.bottom.equalTo(self).offset(0)
            }
            
            self.layoutIfNeeded()
        }
    }
    
    func dismiss(_ animate: Bool) {
        
        self.removeFromSuperview()
    }
    
    var shareInfo:DFFreePlayShareModel!
    

    static  func popView(withShareInfo:DFFreePlayShareModel) -> DFPlatformShareWidget {
         
        let view:DFPlatformShareWidget = DFPlatformShareWidget.init(frame: UIScreen.main.bounds)
        
        view.shareInfo = withShareInfo
        
        view.uiConfigure()
        
        return view
         
        
     }
     
    
    
    
    
     //动态计算 conentview 高度
     var contentHeight:CGFloat = 0
     
     func uiConfigure()  {
         
#if MJ_EmotionDiary
         let btnsdata:[(String,String)] = [("微信","sw_freeplay_share_icon1"),("朋友圈","sw_freeplay_share_icon4"),("复制链接","sw_freeplay_share_icon5")]
         contentHeight = SCALE_HEIGTHS(value: 151) + SCALE_HEIGTHS(value: 54)

#else
         let btnsdata:[(String,String)] = [("微信","sw_freeplay_share_icon1"),("朋友圈","sw_freeplay_share_icon4"),("QQ","sw_freeplay_share_icon3"),("QQ空间","sw_freeplay_share_icon2"),("复制链接","sw_freeplay_share_icon5")]
         contentHeight = SCALE_HEIGTHS(value: 238) + SCALE_HEIGTHS(value: 54)
#endif
         
         self.addSubview(contentView)
         
         
         contentView.backgroundColor = UIColor.white
         
         contentView.snp.makeConstraints { (make) in
             
             make.left.right.equalTo(self)
             make.bottom.equalTo(self).offset(contentHeight)
             make.height.equalTo(contentHeight)
         }
         


         
         
         let padding = SCALE_WIDTHS(value: 25)
         
         let width:CGFloat = 50
         
         let space = (kScreenWidth - padding * 2 - width * 4)/3
         
         for (index,item) in btnsdata.enumerated() {
             
             let btn = UIControl.init(frame: CGRect.zero)
             btn.tag = index
#if MJ_EmotionDiary
             if index > 1 {
                 btn.tag = index + 2
             }
#endif

             let  column = index/4
             let  row = index%4
             
             contentView.addSubview(btn)
             
             btn.snp.makeConstraints { make in
                 
                 make.width.equalTo(width)
                 make.height.equalTo(75)
                 make.left.equalTo(padding + CGFloat(row)*(50 + space))
                 make.top.equalTo(contentView).offset(40 + CGFloat(column) * (80 + 20) )
             }
             
             btn.addTarget(self, action: #selector(itemClicked(with: )), for: .touchUpInside)
             
             let img = UIImageView.init(image: .init(named: item.1))
             btn.addSubview(img)
             img.snp.makeConstraints { make in
                 
                 make.width.height.equalTo(50)
                 make.top.centerX.equalTo(btn)
                
             }
             
             let label = UILabel.lol_getLaberl(content: item.0, fontsize: 14, color: .hexColor("#A1A0AB"), isbold: false)
             btn.addSubview(label)
             label.snp.makeConstraints { make in
                 
                 make.centerX.equalTo(btn)
                 make.top.equalTo(img.snp.bottom).offset(10)
             }
             
             
         }
         
         
         let cancelBtn = UIButton.init(type: .custom)
         cancelBtn.setTitle("取消分享", for: .normal)
         cancelBtn.setTitleColor(.hexColor("#333333"), for: .normal)
         cancelBtn.titleLabel?.font = .systemFont(ofSize: 16)
         contentView.addSubview(cancelBtn)
         cancelBtn.snp.makeConstraints { make in
             
             make.bottom.left.right.equalTo(contentView)
             make.height.equalTo(55)
         }
         cancelBtn.addTarget(self, action: #selector(cancelBtnClicked), for: .touchUpInside)
         
         let line = UIView.init(frame: CGRect.zero)
         line.backgroundColor = .hexColor("#EEEEEE")
         contentView.addSubview(line)
         line.snp.makeConstraints { make in
             
             make.left.right.equalTo(cancelBtn)
             make.bottom.equalTo(cancelBtn.snp.top)
             make.height.equalTo(0.5)
         }
         
     }
    
    
    @objc func cancelBtnClicked()  {
        
        self.dismiss(true)
    }
    
    @objc func itemClicked(with:UIControl)  {
        
       
        
        shareInfo.platform = with.tag
        
        if shareInfo.platform == 4{
            let board =  UIPasteboard.general
            board.string = shareInfo.url
            AutoProgressHUD.showAutoHud( "链接已复制到剪切板")
        }else{
            DFPlatformShareUtil.free_shareTask(with: shareInfo)

        }
        
//
        
        self.dismiss(true)
    }
     override func layoutSubviews() {
         
         super.layoutSubviews()
         
         let radioLayer = CAShapeLayer.init()
             
         radioLayer.frame = contentView.bounds
             
         let path = UIBezierPath.init(roundedRect: contentView.bounds, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 20, height: 20))
         radioLayer.path = path.cgPath
         contentView.layer.mask = radioLayer
     }
    
     
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first, contentView.frame.contains(touch.location(in: self)) == false {
            
            self.dismiss(true)
            
        }
    }
}

