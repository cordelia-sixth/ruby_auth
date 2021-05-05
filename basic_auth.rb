require 'webrick'

# HTTPサーバーを作成
server = WEBrick::HTTPServer.new({
  DocumentRoot: "./",
  BindAddress: "127.0.0.1",
  Port: 8000
})

# 認証情報を記載するファイルを作成
pswd = WEBrick::HTTPAuth::Htpasswd.new("dot.passwd")

# 認証情報を設定
pswd.set_passwd("my_realm", "username", "password")

auth = WEBrick::HTTPAuth::BasicAuth.new(UserDB: pswd, Realm: "my_realm")

# Basic認証を設定する
server.mount_proc("/admin") do |req, res|

  # 認証
  auth.authenticate(req, res)
  res.body = "Welcome my page!"
end

trap("INT"){server.stop}
server.start




# # realmを定義
# realm = "WEBrick realm"

# # サーバー設定
# server = WEBrick::HTTPServer.new({

#   # ドキュメントルート
#   DocumentRoot: '.',

#   # IPアドレス
#   BindAddress: '127.0.0.1',

#   # ポート番号
#   Port: 8000
# })

# # 認証情報を記載するファイルを作成
# htpd = WEBrick::HTTPAuth::Htpasswd.new("dot.htpasswd")

# htpd.set_passwd(nil, "username", "password")

# authenticator = WEBrick::HTTPAuth::BasicAuth.new(UserDB: htpd, Realm: realm)

# server.mount_proc("/basic_auth") { | req, res |
#   authenticator.authenticate(req, res)
#   res.body = 'hoge'
# }

# server.start
