import UIKit
import SnapKit
import Firebase

class SettingsViewController: UIViewController {
    
    
    // MARK: - Properties
    
    lazy var topDescriptionView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.app.background.primary
        return view
    }()
    lazy var pageTipLabel: UILabel = {
        let label = UILabel()
        label.text = "Use this page to modify your account and app settings."
        label.textAlignment = .left
        label.textColor = .darkText
        label.numberOfLines = 0
        return label
    }()
    lazy var accountSettingsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(SettingsViewController.accountSettingsButtonAction), for: .touchUpInside)
        button.setTitle("Account Settings", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(SettingsViewController.logoutButtonAction), for: .touchUpInside)
        button.setTitle("Logout", for: .normal)
        return button
    }()
    
    lazy var settingsTableView: UITableView = {
        let table = UITableView()
        table.isScrollEnabled = false
        table.dataSource = self
        return table
    }()
    
    var settingOptions = ["Profile Settings","Account Settings","App Settings","Logout"]
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LOG: Settings Screen")
        
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingCell")
        settingsTableView.tableFooterView = UIView()
        
        setup()
        addConstraints()
    }
    
    
    // MARK: - Functions
    
    func setup() {
        title = "Settings"
        view.backgroundColor = .gray
        navigationItem.leftBarButtonItems = nil
        
        self.view.addSubview(topDescriptionView)
        topDescriptionView.addSubview(pageTipLabel)
        self.view.addSubview(settingsTableView)
        self.view.addSubview(logoutButton)
        self.view.addSubview(accountSettingsButton)
    }
    
    
    // MARK: - Actions
    
    @objc func logoutButtonAction() {
        print("Lougout Tapped")
        AppManager.shared.logout()
    }
    @objc func accountSettingsButtonAction() {
        print("Account Settings Tapped")

        navigationController?.pushViewController(AccountSettingsViewController(), animated: true)
    }
    
}

// MARK: - Extension: Table View Controller

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath)
        cell.textLabel?.text = settingOptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(AccountSettingsViewController(), animated: true)
    }

}

// MARK: - Extension: Constraints Building

extension SettingsViewController: ConstraintBuilding {
    func addConstraints() {
        topDescriptionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.width.equalTo(self.view)
            make.height.equalTo(200)
        }
        pageTipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(topDescriptionView.snp.left).offset(20)
            make.right.equalTo(topDescriptionView.snp.right).offset(-20)
            make.top.equalTo(topDescriptionView.snp.top).offset(100)
        }
        settingsTableView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.top.equalTo(topDescriptionView.snp.bottom)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        accountSettingsButton.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(100)
            make.center.equalTo(self.view)
        }
        logoutButton.snp.makeConstraints { (make) in
            make.size.equalTo(100)
            make.centerX.equalTo(self.view)
            make.top.equalTo(accountSettingsButton.snp.bottom).offset(20)
        }
    }
}
