require 'webrick'

# HTTPサーバーを作成
server = WEBrick::HTTPServer.new(
  DocumentRoot: "./",
  BindAddress: "127.0.0.1",
  Port: 8000
)

# realm
config = { Realm: "Digest Auth" }

# 認証情報を記載するファイルを作成
htdigest = WEBrick::HTTPAuth::Htdigest.new(".htdigest")

# 認証情報をセット
htdigest.set_passwd(config[:Realm], "username", "password")

# 認証情報をファイルに書き込む
htdigest.flush

# 参照したい認証情報を設定
config[:UserDB] = htdigest

# Digest Authを作成する
auth = WEBrick::HTTPAuth::DigestAuth.new(config)

# 認証をかける
server.mount_proc("/admin") do |req, res|
  auth.authenticate(req, res)
  res.body = "Good morning :)"
end

trap("SIGINT") { server.stop }
server.start
