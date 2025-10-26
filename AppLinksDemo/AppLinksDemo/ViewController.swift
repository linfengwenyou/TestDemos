//
//  ViewController.swift
//  AppLinksDemo
//
//  Created by Buck on 2025/9/23.
//

import UIKit

struct LinkStruct {
    var key: String
    var value: String
}


class ViewController: UIViewController,
                      UITableViewDelegate,
                      UITableViewDataSource {
    
    lazy private var data: [LinkStruct] = linkStrucs()
      lazy var tableView: UITableView = {
        
            let table = UITableView(frame: screenSize(), style: .plain)
            
          table.backgroundColor = .clear
            table.separatorStyle = .none
            table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
            table.sectionHeaderTopPadding = 0
            table.delegate = self
            table.dataSource = self
            
            return table
        }()
        


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.reloadData()
        
        
    }
    
    func screenSize() -> CGRect {
        return view.bounds
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let value = data.count
        print("\(value)")
        return value
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let obj = data[indexPath.row]
    
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        var content = UIListContentConfiguration.subtitleCell()
        content.text = obj.key
        content.secondaryText = obj.value
        
        cell.contentConfiguration = content
        
        let randomColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 0.6)
        cell.backgroundColor = randomColor
        
        return cell
    }
    
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
          let obj = data[indexPath.row]
        UIPasteboard.general.string = obj.value
    }
}


extension ViewController {
    func linkStrucs() -> [LinkStruct] {
        return [
            LinkStruct(key: "我的首页", value: "https://earnest-alpaca-0704f0.netlify.app/index.html"),
            LinkStruct(key: "活动链接", value: "https://www.lbk.world/zh-TC/activity/anniversary-carnival"),
            LinkStruct(key: "首页schem", value: "applink://home"),
            LinkStruct(key: "产品schem", value: "applink://product"),
            LinkStruct(key: "注册schem", value: "applink-login://register"),
            LinkStruct(key: "bybit打开app", value: "https://www.bybit.com/en/task-center/mobile_guide/?__rfk=9zmy98"),
            LinkStruct(key: "bitget", value: "https://www.bitget.com/zh-CN/events/rewards-pack?clacCode=3VP7A2LY"),
            LinkStruct(key: "我的网站测试schem", value: "https://earnest-alpaca-0704f0.netlify.app/testLbank.html"),
            LinkStruct(key: "拉起App打开浏览器", value: "lbank://lbk.app/web?url=https://www.lbk.world/%25language_code%25/activity/qqqqqq7?origin=popular"),
            LinkStruct(key: "hybrid新协议测试页", value: "https://www.lbk.world/zh-TC/js-bridge?backIconType=hidden"),
            LinkStruct(key: "活动测试页", value: "https://www.lbank.com/zh-TC/activity/2046-weekly-new-futures?themeMode=night"),
            LinkStruct(key: "活动测试页", value: "https://www.lbank.com/zh-TC/activity/AAA0912"),
            LinkStruct(key: "视频地址", value: "https://jid.lbk.world/media/customer/userAppeal/8afb79de-0ba4-4aff-8675-1a182d06d340.mp4"),
            LinkStruct(key: "百度新闻", value: "https://baijiahao.baidu.com/s?id=1844053904369404556"),
            LinkStruct(key: "测试暗黑", value: "https://www.lbk.world/zh-TC/community"),
            LinkStruct(key: "测试暗黑2", value: "https://www.lbk.world/zh-TC/activity/bonuspro/test092401"),
            LinkStruct(key: "测试页", value: "https://www.lbk.world/zh-TC/event/starpro3?backIconType=hidden"),
            LinkStruct(key: "自研公告分享", value: "https://www.lbank.com/zh-TC/support/articles/1968929302644785152"),
        ]
    }
}
