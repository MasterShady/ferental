//
//  DeviceDetailVC.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/16.
//

import UIKit
import MapKit
import YYKit
import JXPhotoBrowser
import Kingfisher


class DeviceDetailVC: BaseVC, UIScrollViewDelegate {
    
    let device:Device
    
    var rental: Rental = Rental()
    
    var startTimeItem : SelectItemView?
    var durationItem : SelectItemView?
    var locationItem : SelectItemView?
    
    init(device: Device) {
        self.device = device
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func configSubViews() {
        self.navBarBgAlpha = 0
        self.navBarTintColor = .kDeepBlack
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = .top
        
        self.setBackTitle("",withBg: true)
        
        
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        view.backgroundColor = .init(hexColor: "F8F8F8")
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self
        scrollView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        scrollView.showsVerticalScrollIndicator = false
        
        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(kScreenWidth)
        }
        
        contentView.addSubview(header)
        header.snp.makeConstraints { make in
            make.height.equalTo(kScreenWidth)
            make.top.left.right.equalToSuperview()
        }
        
        
        //let infoViewModule = infoView.encapsulateWithInsets(.init(top: 8, left: 14, bottom: 0, right: 14))
        contentView.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(-5)
            make.left.right.equalToSuperview()
        }
        
        
        
        
        contentView.addSubview(paramsView)
        paramsView.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        //机器详情描述
        let detailTitleLabel = UILabel()
        contentView.addSubview(detailTitleLabel)
        detailTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(paramsView.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
        }
        detailTitleLabel.chain.text("机器详细描述").font(.boldSystemFont(ofSize: 14)).text(color: .kTextBlack)
        
        let leftWing = UIView()
        contentView.addSubview(leftWing)
        leftWing.snp.makeConstraints { make in
            make.right.equalTo(detailTitleLabel.snp.left).offset(-9)
            make.centerY.equalTo(detailTitleLabel)
            make.size.equalTo(CGSize(width: 34, height: 2))
        }
        leftWing.backgroundColor = .kthemeColor
        
        let rightWing = UIView()
        contentView.addSubview(rightWing)
        rightWing.snp.makeConstraints { make in
            make.left.equalTo(detailTitleLabel.snp.right).offset(9)
            make.centerY.equalTo(detailTitleLabel)
            make.size.equalTo(CGSize(width: 34, height: 2))
        }
        rightWing.backgroundColor = .kthemeColor
        
        
        contentView.addSubview(picsView)
        picsView.snp.makeConstraints { make in
            make.top.equalTo(detailTitleLabel.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview()
        }
        
        
        view.addSubview(rentView)
        rentView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(kBottomSafeInset + 60)
            make.top.equalTo(scrollView.snp.bottom)
        }
        
        
        //addFakeNavBar()
    }
    
    
    func updateUI(){
        startTimeItem?.value = rental.fromDate.ymd
        datePicker.setSelectedData(rental.fromDate)
        
        durationItem?.value = String(rental.duration) + "天"
        durationPicker.setSelectedData(rental.duration)
        
        self.confirmView.updateUI()
        
    }
    
    @objc func rent(){
        confirmView.popFromBottom()
    }
    

    
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        let factor = max(1, 1 - scrollView.contentOffset.y / self.header.width)
    
//
//        let baseMatrix = CGAffineTransformIdentity
//
//        let anchor = CGPoint(x: self.header.width/2, y: self.header.height)
//
//        header.transform = CGAffineTransformTranslate(header.transform, -anchor.x, -anchor.y);
//
//        header.transform = CGAffineTransformScale(header.transform, factor, factor);
//
//        header.transform = CGAffineTransformTranslate(header.transform, anchor.x, anchor.y);
        
//        if #available(iOS 16.0, *) {
//            header.anchorPoint = CGPoint(x: self.header.width/2, y: self.header.height)
//        } else {
//            // Fallback on earlier versions
//        }
//        header.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
//        header.transform = CGAffineTransform.init(scaleX: factor, y: factor)
    }
    
    lazy var confirmView: ConfirmView = {
        let confirmView = ConfirmView(device: device, rental: rental)
        confirmView.snp.makeConstraints { make in
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(394 + kBottomSafeInset)
        }
        
        confirmView.confirmHandler = { [weak self] in
            guard let self = self else {return}
            GEPopTool.dimssPopView {
                if UserStore.isLogin{
                    orderService.request(.makeOrder(deviceId: self.device.id, dayCount: self.rental.duration, totalPrice: self.device.price * self.rental.duration)) { result in
                        result.hj_map(Order.self, atKeyPath: "data") { result in
                            switch result {
                            case .success((let order, _)):
                                NotificationCenter.default.post(kUserMakeOrder)
                                let vc = OrderCompletedVC(order:order)
                                self.navigationController?.pushViewController(vc, animated: true)
                            case .failure(let error):
                                AutoProgressHUD.showAutoHud(error.localizedDescription)
                                
                            }
                        }
                        
                        
                    }
                }else{
                    let vc = LoginVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        confirmView.didUpdateRental = {[weak self] _ in
            self?.updateUI()
        }
        
        confirmView.selectDurationHandler = { [weak self] in
            if let self = self{
                self.durationPicker.snp.updateConstraints({ make in
                    make.height.equalTo(self.confirmView.height)
                })
                self.durationPicker.popFromBottom()
            }
        }
        
        confirmView.selectStartTimeHandler = { [weak self] in
            if let self = self{
                self.datePicker.snp.updateConstraints({ make in
                    make.height.equalTo(self.confirmView.height)
                })
                
                self.datePicker.popFromBottom()
            }
            
        }
        return confirmView
    }()
    
    
    lazy var rentView: UIView = {
        let rentView = UIView()
        rentView.backgroundColor = .white
        let btn = UIButton()
        rentView.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
            make.size.equalTo(CGSize(width: 347, height: 44))
        }
        btn.chain.backgroundColor(.kthemeColor).normalTitle(text: "立即租用").font(.boldSystemFont(ofSize: 16)).normalTitleColor(color: .kTextBlack)
            .corner(radius: 6).clipsToBounds(true)
        btn.addTarget(self, action: #selector(rent), for: .touchUpInside)
        
        return rentView
    }()
    
    lazy var header: UIView = {
        let header = UIView()
        let imageView = UIImageView()
        header.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        
        KF.url(.init(subPath: device.cover))
            .fade(duration: 1)
            .loadDiskFileSynchronously()
            .set(to: imageView)
        imageView.kf.indicatorType = .activity
        
        
        let infoView = UIView()
        header.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(36)
        }
        
        
        
        let gradientColor = UIColor.gradient(colors: [.init(hexColor: "#EFF7FF"), .init(hexColor: "#F1FFF3")], from: CGPoint(x: 0, y: 18), to: CGPoint(x:kScreenWidth,y:18), size: CGSize(width: kScreenWidth, height: 36))
        infoView.backgroundColor = gradientColor
        
        let infoImageView = UIImageView()
        infoView.addSubview(infoImageView)
        infoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(16)
        }
        infoImageView.image = .init(named: "device_privilege")
        
        return header
    }()
    
    lazy var infoView: UIView = {
        let infoView = UIView()
        infoView.backgroundColor = .white
        let priceLabel = UILabel()
        infoView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(14)
            make.left.equalTo(14)
        }
        
        let rental = String(format: "%.2f", device.price)
        let raw = String(format: "¥%@元/天", rental)
        let attributedTitle = NSMutableAttributedString(string: raw, attributes: [
            .foregroundColor: UIColor(hexColor: "#F65E19"),
            .font : UIFont.boldSystemFont(ofSize: 18)
        ])
        
        let range = (raw as NSString).range(of: rental)
        attributedTitle.setAttributes([
            .foregroundColor: UIColor(hexColor: "#F65E19"),
            .font : UIFont.boldSystemFont(ofSize: 32)
        ], range: range)
        
        
        let range2 = (raw as NSString).range(of: "/天")
        attributedTitle.setAttributes([
            .foregroundColor: UIColor(hexColor: "#585960"),
            .font : UIFont.systemFont(ofSize: 14)
        ], range: range2)
        
        priceLabel.attributedText = attributedTitle
        
        let sep = UIView()
        infoView.addSubview(sep)
        sep.snp.makeConstraints { make in
            make.left.equalTo(priceLabel.snp.right).offset(8)
            make.bottom.equalTo(priceLabel.snp.lastBaseline)
            make.size.equalTo(CGSize(width: 1, height: 13))
        }
        sep.backgroundColor = .init(hexColor: "D8D8D8")
        
        let depositLabel = UILabel()
        infoView.addSubview(depositLabel)
        depositLabel.snp.makeConstraints { make in
            make.bottom.equalTo(priceLabel.snp.lastBaseline).offset(2)
            make.left.equalTo(sep.snp.right).offset(8)
        }
        depositLabel.chain.font(.systemFont(ofSize: 14)).text(color: .init(hexColor: "#585960")).text(String(format: "押金 ¥%.2f", device.deposit))
        
        
        
        let rentCountLabel = UILabel()
        infoView.addSubview(rentCountLabel)
        rentCountLabel.snp.makeConstraints { make in
            make.right.equalTo(-14)
            make.centerY.equalTo(priceLabel)
        }
        rentCountLabel.chain.text(color: .init(hexColor: "#A1A0AB")).font(.systemFont(ofSize: 12))
        rentCountLabel.text = String(device.rentCount) + "人已租"
        
        let rentTag1 = UILabel()
        infoView.addSubview(rentTag1)
        rentTag1.snp.makeConstraints { make in
            make.top.equalTo(54)
            make.left.equalTo(14)
            make.size.equalTo(CGSize(width: 50, height: 20))
        }
        rentTag1.chain.backgroundColor(.init(hexColor: "#FFF3ED")).corner(radius: 2).clipsToBounds(true).textAlignment(.center).font(.systemFont(ofSize: 11))
            .text(color: .init(hexColor: "#F65E19")).text("租10赠1")
        
        let rentTag2 = UILabel()
        infoView.addSubview(rentTag2)
        rentTag2.snp.makeConstraints { make in
            make.top.equalTo(rentTag1)
            make.left.equalTo(rentTag1.snp.right).offset(6)
            make.size.equalTo(CGSize(width: 50, height: 20))
        }
        rentTag2.chain.backgroundColor(.init(hexColor: "#FFF3ED")).corner(radius: 2).clipsToBounds(true).textAlignment(.center).font(.systemFont(ofSize: 11))
            .text(color: .init(hexColor: "#F65E19")).text("租20赠2")
        
        let titleLabel = UILabel()
        infoView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(rentTag1.snp.bottom).offset(5)
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.bottom.equalTo(-14)
        }
        titleLabel.chain.text(device.name).text(color: .init(hexColor: "333333")).font(.systemFont(ofSize: 17)).numberOfLines(0)
        
        
        DispatchQueue.main.async {
            infoView.addCornerRect(with: [.topLeft,.topRight], radius: 10)
        }
        
        return infoView.encapsulateWithInsets(.init(top: 8, left: 14, bottom: 8, right: 14))
    }()
    
    lazy var paramsView: UIView = {
        let paramsView = UIView()
        paramsView.chain.backgroundColor(.white).corner(radius: 6).clipsToBounds(true)
        
        let hintView = UIView()
        paramsView.addSubview(hintView)
        hintView.backgroundColor = .kthemeColor
        
        let titleLabel = UILabel()
        paramsView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.left.equalTo(14)
        }
        titleLabel.chain.text(color: .kTextBlack).font(.boldSystemFont(ofSize: 16)).text("相关信息完善")
        
        hintView.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel)
            make.left.equalTo(titleLabel)
            make.size.equalTo(CGSize(width: 34, height: 11))
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        paramsView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(45)
        }
        
        startTimeItem = SelectItemView(config: ("起租时间",rental.fromDate.ymd), clickHandler: { [weak self]  in
            if let self = self{
                self.datePicker.snp.updateConstraints{ make in
                    make.height.equalTo(280)
                };
                self.datePicker.popFromBottom()
            }
        })
        let sep = UIView()
        startTimeItem!.addSubview(sep)
        sep.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
        sep.backgroundColor = .init(hexColor: "#EEEEEE")
        
        stackView.addArrangedSubview(startTimeItem!)
        
        
        durationItem = SelectItemView(config: ("租赁时长",String(rental.duration) + "天"), clickHandler: { [weak self] in
            if let self = self{
                self.durationPicker.snp.updateConstraints({ make in
                    make.height.equalTo(280)
                })
                self.durationPicker.popFromBottom()
            }
        })
        stackView.addArrangedSubview(durationItem!)
        
        let sep2 = UIView()
        durationItem!.addSubview(sep2)
        sep2.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
        sep2.backgroundColor = .init(hexColor: "#EEEEEE")
        
        locationItem = SelectItemView(config: ("自提地点",device.address), clickHandler: { [weak self] in
            if let self = self{
                let mapVC = MapVC(coordinate: CLLocationCoordinate2D(latitude: self.device.latitude, longitude: self.device.longitude), name: self.device.address)
                self.navigationController?.pushViewController(mapVC, animated: true)
            }
        })
        stackView.addArrangedSubview(locationItem!)
        
    
        return paramsView.encapsulateWithInsets(.init(top: 0, left: 14, bottom: 0, right: 14))
    }()
    
    
    
    
    lazy var picsView: UIView = {
        let stack = UIStackView()
        stack.axis = .vertical

        device.pics[1...].enumerated().forEach { i, pic in
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            stack.addArrangedSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.width.equalTo(kScreenWidth)
                make.height.greaterThanOrEqualTo(200)
            }
            imageView.backgroundColor = .kExLightGray
            imageView.contentScaleFactor = 2
            
//            let progressive = ImageProgressive(
//                        isBlur: true,
//                        isFastestScan: true,
//                        scanInterval: 0
//                    )
//            progressiveJPEG(progressive),
            
            imageView.kf.indicatorType = .activity
            //.cacheOriginalImage 表示缓存处理之前的图片,否则缓存processor处理后的图片
            imageView.kf.setImage(with: URL(subPath: pic), options: [.cacheOriginalImage,.transition(.fade(1)), .processor(ResizingImageProcessor(referenceSize: .init(width: kScreenWidth , height: CGFloat.infinity), mode: .aspectFit))]){
                if case .success (let result) = $0{
                    imageView.snp.remakeConstraints { make in
                        make.height.equalTo(imageView.snp.width).multipliedBy(result.image.size.height / result.image.size.width)
                    }
                    imageView.kf.setImage(with: URL(subPath: pic))
                }
            }
            imageView.chain.userInteractionEnabled(true).tap {
                let browser = JXPhotoBrowser()
                // 浏览过程中实时获取数据总量
                browser.numberOfItems = { [weak self] in
                    self?.device.pics.count ?? 0
                }
                // 刷新Cell数据。本闭包将在Cell完成位置布局后调用。
                browser.reloadCellAtIndex = { [weak self] context in
                    let browserCell = context.cell as? JXPhotoBrowserImageCell
                    if let urlStr = self?.device.pics[context.index]{
                        browserCell?.imageView.kf.setImage(with: URL(subPath: urlStr))
                    }
                }
                // 可指定打开时定位到哪一页
                browser.pageIndex = i + 1
                // 展示
                browser.show()
            }
            
        }
        
        
        
        return stack
    }()
    
    
    lazy var datePicker: DatePicker = {
        let title = NSMutableAttributedString(string:"选择起租时间")
        title.setAttributes([
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.kTextBlack,
        ], range: title.range)
        
        
        let fromDate = Date()
        let toDate = fromDate.addingTimeInterval(86400 * 60.0)
        let picker = DatePicker(title: title, fromDate: fromDate, toDate: toDate) { [weak self] date in
            GEPopTool.dimssPopView()
            self?.rental.fromDate = date
            self?.updateUI()
        }
        picker.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: kScreenWidth, height: 280))
        };

        return picker
    }()
    
    
    lazy var durationPicker: SinglePicker<Int> = {
        let title = NSMutableAttributedString(string:"选择租赁时常")
        title.setAttributes([
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.kTextBlack,
        ], range: title.range)
    
        
        let picker = SinglePicker<Int>(title: title, data: AppData.rentDuration) { [weak self ] duration in
            GEPopTool.dimssPopView()
            self?.rental.duration = duration
            self?.updateUI()
        } titleForDatum: { duration in
            return String(duration) + "天"
        }
        
        picker.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: kScreenWidth, height: 280))
        };

        return picker

    }()
    
}




