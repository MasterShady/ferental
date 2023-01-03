//
//  DeviceCard.swift
//  ferental
//
//  Created by 刘思源 on 2022/12/28.
//

import Foundation

class DeviceCard : BaseView{
    private lazy var cover = UIImageView()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.chain.font(.boldSystemFont(ofSize: 14)).text(color: UIColorFromHex("333333")).numberOfLines(0)
        return label
    }()
    private lazy var cpuLabel = UILabel()
    private lazy var gpuLabel = UILabel()
    private lazy var screenSizeLabel = UILabel()
    private lazy var depositeLabel = UILabel()
    private lazy var rentalLabel = UILabel()
    
    var device : Device?{
        didSet{
            cover.kf.setImage(with: URL(string: device?.cover ?? ""))
            titleLabel.text = device?.title
            cpuLabel.text = device?.cpu
            gpuLabel.text = device?.gpu
            screenSizeLabel.text = String(format: "%.1f 英寸", device?.screenSize ?? 0)
            depositeLabel.text = String(format: "押金 ¥ %.0f", device?.deposit ?? 0)
            
            let rental = String(format: "%.2f", device?.rentalFee ?? 0)
            let raw = String(format: "¥%@元/天", rental)
            let attributedTitle = NSMutableAttributedString(string: raw, attributes: [
                NSAttributedString.Key.foregroundColor: UIColorFromHex("#F65E19"),
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 10)
            ])
            
            let range = (raw as NSString).range(of: rental)
            attributedTitle.setAttributes([
                NSAttributedString.Key.foregroundColor: UIColorFromHex("#F65E19"),
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)
            ], range: range)
            
            let range2 = (raw as NSString).range(of: "/天")
            attributedTitle.setAttributes([
                NSAttributedString.Key.foregroundColor: UIColorFromHex("#585960"),
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)
            ], range: range2)
            
            rentalLabel.attributedText = attributedTitle
        }
    }
    
    override func configSubviews() {
        
        self.chain.backgroundColor(.white).corner(radius: 7).clipsToBounds(true)
        self.addSubview(cover)
        cover.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(12)
            make.width.equalTo(105)
            make.height.equalTo(105)
            make.bottom.equalTo(-12)
        }
        cover.chain.corner(radius: 2).clipsToBounds(true)
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(cover.snp.right).offset(8)
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(36)
        }
        
        let paramsView = UIView()
        self.addSubview(paramsView)
        paramsView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.right.equalTo(titleLabel)
            make.height.equalTo(35)
        }
        paramsView.backgroundColor = .gradient(fromColors: [.init(hexColor: "#EFF7FF"),.init(hexColor: "#F1FFF3")], size: CGSize(width: 1, height: 1))
        
        
        let makeItem: (String,UIView) -> UILabel = { title, superView in
            let keyLabel = UILabel()
            superView.addSubview(keyLabel)
            keyLabel.chain.font(.boldSystemFont(ofSize: 11)).text(color: .kTextDarkGray).text(title)
            keyLabel.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-3)
                make.centerX.equalToSuperview()
            }
            let valueLabel = UILabel()
            superView.addSubview(valueLabel)
            valueLabel.chain.font(.boldSystemFont(ofSize: 9)).text(color: .kTextGray).textAlignment(.center)
            valueLabel.snp.makeConstraints { make in
                make.bottom.equalTo(keyLabel.snp.top).offset(-1)
                make.left.right.equalToSuperview()
            }
            return valueLabel
        }

        
        var lastpart: UIView?
        for i in 0..<3 {
            let part = UIView()
            paramsView.addSubview(part)
            if let lastpart = lastpart{
                part.snp.makeConstraints { make in
                    make.width.equalToSuperview().dividedBy(3)
                    make.left.equalTo(lastpart.snp.right)
                    make.top.bottom.equalToSuperview()
                }
            }else{
                part.snp.makeConstraints { make in
                    make.width.equalToSuperview().dividedBy(3)
                    make.top.left.bottom.equalToSuperview()
                }
            }
            if i != 2{
                let sep = UIView()
                part.addSubview(sep)
                sep.backgroundColor = .init(hexString: "#DADAE0")
                sep.snp.makeConstraints { make in
                    make.height.equalTo(15)
                    make.width.equalTo(0.5)
                    make.right.equalToSuperview()
                    make.centerY.equalToSuperview()
                }
            }
            
            if i == 0{
                 cpuLabel = makeItem("处理器", part)
            } else if i == 1{
                gpuLabel = makeItem("显卡型号", part)
            } else{
                screenSizeLabel  = makeItem("屏幕尺寸", part)
            }
            
            lastpart = part
        }
        
            
        self.addSubview(rentalLabel)
        rentalLabel.snp.makeConstraints { make in
            make.left.equalTo(paramsView)
            make.top.equalTo(paramsView.snp.bottom).offset(9)
        }
        
        
        self.addSubview(depositeLabel)
        depositeLabel.font = .systemFont(ofSize: 10)
        depositeLabel.textColor = .kTextGray
        depositeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(rentalLabel).offset(-2)
            make.left.equalTo(rentalLabel.snp.right).offset(5)
        }
    }
}


class DeviceCell: UITableViewCell{
    
    lazy var deviceCard = DeviceCard(frame: .zero)
    
    var device : Device?{
        didSet{
            deviceCard.device = device
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(){
        selectionStyle = .none
        backgroundColor = .clear
        //let container = UIView()
        deviceCard.backgroundColor = .white
        contentView.addSubview(deviceCard)
        deviceCard.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        }
        deviceCard.chain.corner(radius: 3).clipsToBounds(true)
    }
    
    
    private lazy var cover = UIImageView()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.chain.font(.boldSystemFont(ofSize: 14)).text(color: UIColorFromHex("333333")).numberOfLines(0)
        return label
    }()
    private lazy var cpuLabel = UILabel()
    private lazy var gpuLabel = UILabel()
    private lazy var screenSizeLabel = UILabel()
    private lazy var depositeLabel = UILabel()
    private lazy var rentalLabel = UILabel()
    
    
    
}

