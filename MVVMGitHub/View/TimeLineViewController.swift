//
//  TimeLineViewController.swift
//  MVVMGitHub
//
//  Created by 小野寺祥吾 on 2022/01/01.
//

import Foundation
import UIKit
import SafariServices

final class TimeLineViewController: UIViewController {
    fileprivate var viewModel: UserListViewModel!
    fileprivate var tableView: UITableView!
    fileprivate var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         tableView を生成
         */
        tableView = UITableView(frame:view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TimeLineCell.self, forCellReuseIdentifier: "TimeLineCell")
        view.addSubview(tableView)
        
        /*
         UIRefreshControlを生成し、リフレッシュしたときに呼ばれるメソッドを定義し、
         tableView.refreshControlにセットしている
         */
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlValueDidChange(sender:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        /*
         UserListViewModelを生成し、通知を受け取ったときの処理を定義している
         */
        viewModel = UserListViewModel()
        viewModel.stateDidUpdate = { [weak self] state in
            switch state {
            case .loading:
                /*
                 通信中だったら、tableViewを操作不能にしている
                 */
                self?.tableView.isUserInteractionEnabled = false
                break
            case .finish:
                /*
                 通信が完了したら、tableViewを操作可能にし、tableViewを更新、また、refreshControl.endRefreshingを読んでいる
                 */
                self?.tableView.isUserInteractionEnabled = true
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
                break
            case .error(let error):
                /*
                 Errorだったら、tableViewを操作可能にし
                 また、refureshControl.endRefreshingを読んでいる
                 その後、ErrorメッセージAlertを表示している
                 */
                self?.tableView.isUserInteractionEnabled = true
                self?.refreshControl.endRefreshing()
                
                let alertController = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(alertAction)
                self?.present(alertController,animated: true,completion: nil)
                break
            }
        }
        /*
         ユーザ一覧を取得している
         */
        viewModel.getUsers()
    }
    
    @objc func refreshControlValueDidChange(sender: UIRefreshControl) {
        /*
         リフレッシュしたとき、ユーザ一覧を取得している
         */
        viewModel.getUsers()
    }
        
}

extension TimeLineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    /*
     viewModel.usersCount()をtableViewのCellの数として設定している
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("viewModel.usersCount():\(viewModel.usersCount())")
        return viewModel.usersCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let timelineCell = tableView.dequeueReusableCell(withIdentifier: "TimeLineCell") as? TimeLineCell {
            /*
             そのCellのUserCellViewModelを取得し、timelineClellに対して、nickNameとiconをセットしている
             */
            let cellViewModel = viewModel.cellviewModels[indexPath.row]
            timelineCell.setNickName(nickNmae: cellViewModel.nickName)
            cellViewModel.downloadImage { (progress) in
                switch progress {
                case .loading(let image):
                    timelineCell.setIcon(icon: image)
                    break
                case .finish(let image):
                    timelineCell.setIcon(icon: image)
                    break
                case .error:
                    break
                }
            }
            return timelineCell
        }
        fatalError()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        /*
         そのCellのUserCellViewModelを取得し、そのユーザのGithubページへ画面遷移している
         */
        let cellViewModel = viewModel.cellviewModels[indexPath.row]
        let html_url = cellViewModel.html_url
        let webViewController = SFSafariViewController(url: html_url)
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
}


