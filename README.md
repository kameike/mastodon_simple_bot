# Pawooでbotが動くよ！やったね
[Selenium](http://seleniumhq.github.io/selenium/docs/api/rb/Selenium.html)からポストするナウでヤングでエモなbot。
done is better than perfectって偉い人が言っていた。

できること
- 文言を一定間隔でランダムに投稿する

**パスワードを入れたままでのpushなどに気をつけてください:bow:**
もう少ししたら改善します多分

[モチベーション](https://pawoo.net/@love_arai_san)

**TODOS**
- [x] ~~ハードコーディングの部分の外部ファイル化~~
- [x] ~~複数アカウント対応~~
- [x] ~~ouath2でcui化~~
- [ ] ネイティオを倒すためハトのbotを作る 
- [ ] 時間指定投稿

## 導入例
`https://pawoo.net`に`hoge@email.com` パスワード`hogehoge`で登録している
アカウントをbotとして運用して見ましょう。30分に一回ランダムにフレーズを
tootさせてみます

1. `account.toml.example`をコピーして`account.toml`を作成しますそして、`acccunt.toml`を以下の感じで変更します
```toml
[[account]]
name = "トキ" # この名前はこのアプリ上で使われるだけの識別子です
client_name = "高原" # これはmastodon上でどのクライアントからの投稿かわかる識別子です。表示されます
host_url = "https://pawoo.net"
password = "hogehoge"
email = "hoge@emai.com"
setting_file = "settings/toki.toml"
```

2. `acccunt.toml`で指定した`settings/toki.toml`をよしなに編集します。30分に一回なので1800秒に一回の設定にします
```toml
[post.random]
interval = 1800 #seconds
phrases = """
仲間をさがしているの
せめて痛みを知らずに 安らかに死ぬがよい・・
"""
```

3.　`bundle exec ruby app/main.rb`のコマンドでbotが起動します。
初回起動時のみそれぞれのサービスからアドレスとパスワードを使い
認可トークンをを取得します。トークンは`.tokens.yaml`に保存され
アプリの`client_id`, `client_secret`は`.app_keys.yaml`に保存されます。
