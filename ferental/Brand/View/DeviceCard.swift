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
        label.chain.font(.boldSystemFont(ofSize: 14)).text(color: .init(hexColor: "333333")).numberOfLines(0)
        return label
    }()
    private var cpuLabel: UILabel!
    
    //手机显示内存,电脑显示gpu
    private var secondValueLabel: UILabel!
    private var secondKeyLabel: UILabel!
    
    private var screenSizeLabel: UILabel!
    
    private lazy var depositeLabel = UILabel()
    private lazy var rentalLabel = UILabel()
    
    var device : Device?{
        didSet{
            guard let device = device else {return}
            cover.kf.setImage(with: URL(subPath: device.cover))
            titleLabel.text = device.name
            cpuLabel.text = device.cpu
            if let memory = device.memory{
                
                secondKeyLabel.text = "内存"
                secondValueLabel.text = memory + "G"
                
            }else if let gpu = device.gpu{
                secondKeyLabel.text = "显卡型号"
                secondValueLabel.text = gpu
            }
            
            
            screenSizeLabel.text = String(format: "%@ 英寸", device.screenSize)
            depositeLabel.text = String(format: "押金 ¥ %.0f", device.deposit)
            
            let rental = String(format: "%.2f", device.price)
            let raw = String(format: "¥%@元/天", rental)
            let attributedTitle = NSMutableAttributedString(string: raw, attributes: [
                .foregroundColor: UIColor(hexColor: "#F65E19"),
                .font : UIFont.boldSystemFont(ofSize: 10)
            ])
            
            let range = (raw as NSString).range(of: rental)
            attributedTitle.setAttributes([
                .foregroundColor: UIColor(hexColor: "#F65E19"),
                .font : UIFont.boldSystemFont(ofSize: 18)
            ], range: range)
            
            let range2 = (raw as NSString).range(of: "/天")
            attributedTitle.setAttributes([
                .foregroundColor: UIColor(hexColor: "#585960"),
                .font : UIFont.systemFont(ofSize: 10)
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
        cover.chain.corner(radius: 2).clipsToBounds(true).backgroundColor(.kExLightGray).contentMode(.scaleAspectFill)
        
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
        
        
        let makeItem: (String,UIView) -> (UILabel,UILabel) = { title, superView in
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
            return (keyLabel, valueLabel)
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
                cpuLabel = makeItem("处理器", part).1
            } else if i == 1{
                  (secondKeyLabel,secondValueLabel) = makeItem("显卡型号", part)
            } else{
                screenSizeLabel  = makeItem("屏幕尺寸", part).1
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
    
 
    
    
    
}

