require 'webrick'

# HTTPサーバーを作成
server = WEBrick::HTTPServer.new(
  DocumentRoot: "./",
  BindAddress: "127.0.0.1",
  Port: 8000
)

# 認証情報を記載するファイルを作成
passwd = WEBrick::HTTPAuth::Htpasswd.new(".passwd")

# 認証情報をセットする
passwd.set_passwd("my_realm", "username", "password")

# Basic認証を設定する
auth = WEBrick::HTTPAuth::BasicAuth.new(UserDB: passwd, Realm: "my_realm")

# Basic認証をかける
server.mount_proc("/admin") do |req, res|

  # 認証情報をチェックする
  auth.authenticate(req, res)
  res.body = "Welcome!"
end

# ctrl + C 押されたらサーバーを終了する
trap("SIGINT") { server.stop }

# サーバー起動
server.start
