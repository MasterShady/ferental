//
//  lolm_actDetail_shareImg_alert_view.swift
//  lolmTool
//
//  Created by cc苹果盒子 on 2022/6/21.
//

import UIKit

class lolm_actDetail_shareImg_alert_view: lolm_base_widget {

    
    let bottomViewHeight = SCALE_WIDTHS(value: 166) + SCALE_WIDTHS(value: 54) + BOTTOM_HEIGHT
    
    let imageViewHeight = SCALE_WIDTHS(value: 385)
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = .clear
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //展示
    func show() {
        self.superview?.layoutIfNeeded()
        UIView.animate(withDuration: TimeInterval(0.35)) {
            self.backgroundColor = UIColor.init(hexString: "#000000").withAlphaComponent(0.6)
            self.bgView.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.snp.bottom).offset(0)
            }
            self.layoutIfNeeded()
        }
    }
    //显示
    func dismiss() {
        UIView.animate(withDuration: TimeInterval(0.35)) {
            self.backgroundColor = .clear
            self.bgView.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.snp.bottom).offset(self.bottomViewHeight + self.imageViewHeight + SCALE_WIDTHS(value: 20))
            }
            self.layoutIfNeeded()
        } completion: { result in
            self.removeFromSuperview()
        }
    }
    
    //点击取消
    @objc open func cancelBtnAction(button:UIButton){
        dismiss();
    }
    
    var itemBtnClickedBlock:((Int,UIImage)->())?
    @objc func itemClicked(with:UIControl)  {
        
        UIGraphicsBeginImageContextWithOptions(self.shareImgBgView.size, false, UIScreen.main.scale)
        
        
        
        
//        UIGraphicsBeginImageContext(UIScreen.main.bounds.size)
        self.shareImgBgView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage.init()
        UIGraphicsEndImageContext()
        
        itemBtnClickedBlock?(with.tag,image)
        self.dismiss()
    }
    
    
    
//    var rentModel:Lolmdf_ActRentModel? {
//        willSet{
//            self.shareImgPic.kf.setImage(with: URL(string: newValue?.app_game_banner ?? ""))
//
//            self.shareImgContentLabel.attributed.text =
//                """
//                \("\(newValue?.pn ?? "")",.paragraph(with: [.lineSpacing(4)]))
//                """
//            self.shareImgContentLabel.sizeToFit()
//
//            self.shareImgTypeLabel.text = "\(newValue?.game_name ?? "")/\(newValue?.game_server_name ?? "")/\(newValue?.game_zone_name ?? "")"
//
//            let price:Float = newValue?.pmoney ?? 0
//            self.shareImgPriceLabel.attributed.text =
//
//                """
//                \("￥",.foreground(UIColor.init(hexString: "#FE3F6D")),.font(SW_FOUNT(size: 10, weight: .semibold)))\("\(price)",.foreground(UIColor.init(hexString: "#F6194F")),.font(SW_FOUNT(size: 18, weight: .semibold)))/时
//                """
//
//
//            self.shareImgQRLabel.attributed.text =
//                """
//                \("长按识别二维码，可以查看账号详情",.paragraph(with: [.lineSpacing(10)]))
//                """
//
//            DispatchQueue.global().async {
//                let url = newValue?.share_url ?? ""
//                let filter = CIFilter.init(name: "CIQRCodeGenerator")
//                filter?.setDefaults()
//                // Add Data
//                let data = url.data(using: .utf8)//链接转换
//                filter?.setValue(data, forKeyPath: "inputMessage")
//                let outputImage = filter?.outputImage/// Out Put
//                let image = lolm_actDetail_shareImg_alert_view.createUIImageFromCIImage(image: outputImage!, size: 1024)
//
//                DispatchQueue.main.async {
//                    self.shareImgQR.image = image
//                }
//            }
//
//            let infoDict:[String : Any] = Bundle.main.infoDictionary!
//            let CFBundleIcons:[String : Any] = infoDict["CFBundleIcons"] as! [String : Any]
//            let CFBundlePrimaryIcon:[String : Any] = CFBundleIcons["CFBundlePrimaryIcon"] as! [String : Any]
//            let iconsArr:[String] = CFBundlePrimaryIcon["CFBundleIconFiles"] as! [String]
//            self.shareImgQRLogo.image = UIImage(named: iconsArr.last ?? "AppIcon60x60")//
//
//        }
//    }
    
    //创建二维码
    static func createUIImageFromCIImage(image: CIImage, size: CGFloat) -> UIImage {
            let extent = image.extent.integral
            let scale = min(size / extent.width, size / extent.height)
                
            /// Create bitmap
            let width: size_t = size_t(extent.width * scale)
            let height: size_t = size_t(extent.height * scale)
            let cs: CGColorSpace = CGColorSpaceCreateDeviceGray()
            let bitmap: CGContext = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 1)!
           
            ///
            let context = CIContext.init()
            let bitmapImage = context.createCGImage(image, from: extent)
            bitmap.interpolationQuality = .none
            bitmap.scaleBy(x: scale, y: scale)
            bitmap.draw(bitmapImage!, in: extent)
                
            let scaledImage = bitmap.makeImage()
            return UIImage.init(cgImage: scaledImage!)
        }
    func updataContentBgView() {
        contentBgView.subviews.forEach{$0.removeFromSuperview()}
        
        //("微信","sw_freeplay_share_icon1"),("朋友圈","sw_freeplay_share_icon4"),("QQ","sw_freeplay_share_icon3")
        let btnsdata:[(String,String)] = [("保存图片","sw_actdetail_share_savePic")]

        
        
        let width:CGFloat = SCALE_WIDTHS(value: 50)
        let height:CGFloat = SCALE_WIDTHS(value: 72)
        
        let padding = SCALE_WIDTHS(value: 40)
        
        let space = (SCREEN_WIDTH - padding * 2 - width * 4)/3
        
        for (index,item) in btnsdata.enumerated() {
            
            let btn = UIControl.init(frame: CGRect.zero)
            btn.tag = index
            let  column = index/4
            let  row = index%4
            
            contentBgView.addSubview(btn)
            
            btn.snp.makeConstraints { make in
                
                make.width.equalTo(width)
                make.height.equalTo(height)
                make.left.equalTo(padding + CGFloat(row)*(width + space))
                make.top.equalTo(CGFloat(column) * (height + SCALE_WIDTHS(value: 15)))
            }
            
            btn.addTarget(self, action: #selector(itemClicked(with: )), for: .touchUpInside)
            
            let img = UIImageView.init(image: .init(named: item.1, in: PKGUICinfig.bundle, with: nil))
            btn.addSubview(img)
            img.snp.makeConstraints { make in
                make.width.height.equalTo(width)
                make.top.equalTo(0)
                make.left.equalTo(0)
            }
            
            let label = UILabel.lol_getLaberl(content: item.0, fontsize: 14, color: .hexColor("#A1A0AB"), isbold: false)
            btn.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerX.equalTo(btn)
                make.top.equalTo(img.snp.bottom).offset(SCALE_WIDTHS(value: 7))
            }
        }
        
    }
    
    override func uiConfigure() {
        self.addSubview(self.bgView)
        self.bgView.addSubview(self.titleLabel)
        self.bgView.addSubview(self.contentBgView)
        self.bgView.addSubview(self.line1)
        self.bgView.addSubview(self.cancelBtn)
        self.bgView.addSubview(self.line2)
        self.bgView.addSubview(self.line2)
        
        
        self.addSubview(self.shareImgBgView)
//        self.shareImgBgView.addSubview(self.shareImgtitleImage)
//        self.shareImgBgView.addSubview(self.shareImgPic)
//        self.shareImgBgView.addSubview(self.shareImgContentLabel)
//        self.shareImgBgView.addSubview(self.shareImgTypeLabel)
//        self.shareImgBgView.addSubview(self.shareImgPriceLabel)
//        self.shareImgBgView.addSubview(self.shareImgline)
//        self.shareImgBgView.addSubview(self.shareImgQR)
//        self.shareImgQR.addSubview(self.shareImgQRLogo)
//        self.shareImgBgView.addSubview(self.shareImgQRLabel)
        
        
        
    }
    override func myAutoLayout() {
        bgView.snp.makeConstraints { (make) in
            make.height.equalTo(bottomViewHeight)
            make.bottom.equalTo(self.snp.bottom).offset(bottomViewHeight)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
        }
        bgView.layer.cornerRadius = SCALE_WIDTHS(value: 20)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.bgView.snp.top).offset(SCALE_WIDTHS(value: 18))
            make.height.equalTo(SCALE_WIDTHS(value: 18))
            make.left.equalTo(self.bgView.snp.left)
            make.right.equalTo(self.bgView.snp.right)
        }
        
        contentBgView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(SCALE_WIDTHS(value: 18))
            make.left.equalTo(self.bgView.snp.left)
            make.right.equalTo(self.bgView.snp.right)
            make.bottom.equalTo(self.cancelBtn.snp.top)
        }
        line1.snp.makeConstraints { (make) in
            make.top.equalTo(self.cancelBtn.snp.top)
            make.left.equalTo(self.bgView.snp.left)
            make.right.equalTo(self.bgView.snp.right)
            make.height.equalTo(1)
        }
        
        cancelBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.bgView.snp.bottom).offset(-BOTTOM_HEIGHT)
            make.height.equalTo(SCALE_WIDTHS(value: 54))
            make.left.equalTo(self.bgView.snp.left)
            make.right.equalTo(self.bgView.snp.right)
        }
        
        line2.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.bgView.snp.bottom)
            make.left.equalTo(self.bgView.snp.left)
            make.right.equalTo(self.bgView.snp.right)
            make.height.equalTo(SCALE_WIDTHS(value: 20))
        }
        
        
        
        
        shareImgBgView.snp.makeConstraints { (make) in
            make.height.equalTo(imageViewHeight)
            make.width.equalTo(SCALE_WIDTHS(value: 275))
            make.bottom.equalTo(self.bgView.snp.top).offset(-SCALE_WIDTHS(value: 20))
            make.centerX.equalTo(self.snp.centerX)
        }
        shareImgBgView.layer.cornerRadius = SCALE_WIDTHS(value: 16)
        
//        shareImgtitleImage.snp.makeConstraints { (make) in
//            make.height.equalTo(SCALE_WIDTHS(value: 27))
//            make.width.equalTo(SCALE_WIDTHS(value: 201))
//            make.top.equalTo(self.shareImgBgView.snp.top).offset(SCALE_WIDTHS(value: 7))
//            make.centerX.equalTo(shareImgBgView.snp.centerX)
//        }
//
//        shareImgPic.snp.makeConstraints { (make) in
//            make.top.equalTo(shareImgtitleImage.snp.bottom).offset(SCALE_WIDTHS(value: 7))
//            make.height.equalTo(SCALE_WIDTHS(value: 160))
//            make.left.equalTo(shareImgBgView.snp.left).offset(SCALE_WIDTHS(value: 14))
//            make.right.equalTo(shareImgBgView.snp.right).offset(-SCALE_WIDTHS(value: 14))
//        }
//        shareImgPic.layer.cornerRadius = SCALE_WIDTHS(value: 8)
//        shareImgPic.layer.masksToBounds = true
//
//        shareImgContentLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(shareImgPic.snp.bottom).offset(SCALE_WIDTHS(value: 8))
////            make.height.equalTo(SCALE_WIDTHS(value: 40))
//            make.left.equalTo(shareImgBgView.snp.left).offset(SCALE_WIDTHS(value: 14))
//            make.right.equalTo(shareImgBgView.snp.right).offset(-SCALE_WIDTHS(value: 14))
//        }
//
//        shareImgTypeLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(shareImgContentLabel.snp.bottom).offset(SCALE_WIDTHS(value: 10.5))
//            make.height.equalTo(12)
//            make.left.equalTo(shareImgBgView.snp.left).offset(SCALE_WIDTHS(value: 14))
//            make.width.equalTo(SCALE_WIDTHS(value: 180))
//        }
//
//        shareImgPriceLabel.snp.makeConstraints { (make) in
//            make.centerY.equalTo(shareImgTypeLabel.snp.centerY)
//            make.height.equalTo(SCALE_WIDTHS(value: 16))
//            make.right.equalTo(shareImgBgView.snp.right).offset(-SCALE_WIDTHS(value: 14))
//            make.width.equalTo(SCALE_WIDTHS(value: 80))
//        }
//
//        shareImgline.snp.makeConstraints { (make) in
//            make.bottom.equalTo(shareImgBgView.snp.bottom).offset(-SCALE_WIDTHS(value: 90))
//            make.height.equalTo(1)
//            make.left.equalTo(shareImgBgView.snp.left).offset(SCALE_WIDTHS(value: 14))
//            make.right.equalTo(shareImgBgView.snp.right).offset(-SCALE_WIDTHS(value: 14))
//        }
//
//        shareImgQR.snp.makeConstraints { (make) in
//            make.bottom.equalTo(shareImgBgView.snp.bottom).offset(-SCALE_WIDTHS(value: 12))
//            make.height.equalTo(SCALE_WIDTHS(value: 66))
//            make.width.equalTo(SCALE_WIDTHS(value: 66))
//            make.right.equalTo(shareImgBgView.snp.right).offset(-SCALE_WIDTHS(value: 14))
//        }
//
//        shareImgQRLogo.snp.makeConstraints { (make) in
//            make.center.equalTo(shareImgQR.snp.center)
//            make.height.equalTo(SCALE_WIDTHS(value: 16))
//            make.width.equalTo(SCALE_WIDTHS(value: 16))
//        }
//        shareImgQRLogo.layer.cornerRadius = SCALE_WIDTHS(value: 5)
//        shareImgQRLogo.layer.masksToBounds = true
//
//
//        shareImgQRLabel.snp.makeConstraints { (make) in
//            make.centerY.equalTo(shareImgQR.snp.centerY)
//            make.right.equalTo(shareImgQR.snp.left).offset(-SCALE_WIDTHS(value: 20))
//            make.left.equalTo(shareImgBgView.snp.left).offset(SCALE_WIDTHS(value: 14))
//        }
        
        self.layoutIfNeeded()
        updataContentBgView()
    }
    
    
    
    
    
 
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = SW_FOUNT(size: 18, weight: .semibold)
        label.textColor = UIColor(hexString: "#222222")
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "分享当前图片到"
        return label
    }()
    lazy var contentBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    lazy var line1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#EEEEEE")
        return view
    }()
    lazy var cancelBtn: UIButton = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = .clear
        button.setTitle("取消分享", for: .normal)
        button.setTitleColor(UIColor(hexString: "#222222"), for: .normal)
        button.titleLabel?.font = SW_FOUNT(size: 16, weight: .regular)
        button.addTarget(self, action: #selector(cancelBtnAction(button:)), for: .touchUpInside)
        button.showsTouchWhenHighlighted = false
        return button
    }()
    lazy var line2: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var shareImgBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
//    lazy var shareImgtitleImage: UIButton = {
//        let button = UIButton.init(type: .custom)
//        button.backgroundColor = .clear
//        button.setBackgroundImage(UIImage(named: "sw_actdetail_share_titlebg"), for: .disabled)
//        button.setTitle("发现一个宝藏账号，推荐给你", for: .disabled)
//        button.setTitleColor(UIColor(hexString: "#333333"), for: .disabled)
//        button.titleLabel?.font = SW_FOUNT(size: 12, weight: .regular)
//        button.isEnabled = false
//        return button
//    }()
//
//    lazy var shareImgPic: UIImageView = {
//        let imageView = UIImageView()
//        imageView.backgroundColor = .clear
//        return imageView
//    }()
//
//    lazy var shareImgContentLabel: UILabel = {
//        let label = UILabel()
//        label.backgroundColor = .clear
//        label.font = SW_FOUNT(size: 14, weight: .medium)
//        label.textColor = UIColor(hexString: "#333333")
//        label.numberOfLines = 2
//        label.textAlignment = .left
//        return label
//    }()
//    lazy var shareImgTypeLabel: UILabel = {
//        let label = UILabel()
//        label.backgroundColor = .clear
//        label.font = SW_FOUNT(size: 12, weight: .regular)
//        label.textColor = UIColor(hexString: "#A1A0AB")
//        label.numberOfLines = 1
//        label.textAlignment = .left
//        return label
//    }()
//    lazy var shareImgPriceLabel: UILabel = {
//        let label = UILabel()
//        label.backgroundColor = .clear
//        label.font = SW_FOUNT(size: 12, weight: .regular)
//        label.textColor = UIColor(hexString: "#A1A0AB")
//        label.numberOfLines = 1
//        label.textAlignment = .right
//        return label
//    }()
//
//    lazy var shareImgline: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor(hexString: "#EEEEEE")
//        return view
//    }()
//
//
//    lazy var shareImgQR: UIImageView = {
//        let imageView = UIImageView()
//        imageView.backgroundColor = .clear
//        return imageView
//    }()
//    lazy var shareImgQRLogo: UIImageView = {
//        let imageView = UIImageView()
//        imageView.backgroundColor = .clear
//        return imageView
//    }()
//    lazy var shareImgQRLabel: UILabel = {
//        let label = UILabel()
//        label.backgroundColor = .clear
//        label.font = SW_FOUNT(size: 13, weight: .regular)
//        label.textColor = UIColor(hexString: "#A1A0AB")
//        label.numberOfLines = 2
//        label.textAlignment = .left
//        return label
//    }()
}
class DFScreenShortSharedWidget:lolm_actDetail_shareImg_alert_view  {
    
    
    var imageData:Data!
    
    var screenImageView:UIImageView!
        
    override func uiConfigure() {
        
        super.uiConfigure()
        
        shareImgBgView.subviews.forEach { tmp in
            
            tmp.isHidden = true
        }
        
    }
    
    override func show() {
        
        screenImageView = UIImageView.init(image: UIImage(data: imageData))
        shareImgBgView.clipsToBounds = true
        shareImgBgView.addSubview(screenImageView)
        screenImageView.snp.makeConstraints { make in
            
            make.edges.equalTo(shareImgBgView)
        }
        
        super.show()
    }
    
    @objc override func itemClicked(with:UIControl)  {
        
       
        
        itemBtnClickedBlock?(with.tag,UIImage(data: imageData)!)
        
    }
}
