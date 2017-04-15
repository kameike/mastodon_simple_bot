# Pawooでbotが動くよ！やったね
[Selenium](http://seleniumhq.github.io/selenium/docs/api/rb/Selenium.html)からポストするナウでヤングでエモなbot。
done is better than perfectって偉い人が言っていた。

できること
- 文言を一定間隔でランダムに投稿する

**パスワードを入れたままでのpushなどに気をつけてください:bow:**
もう少ししたら改善します多分

[モチベーション](https://pawoo.net/@love_arai_san)

**TODOS**
- [ ] ハードコーディングの部分の外部ファイル化
- [ ] 複数アカウント対応
- [ ] ネイティオを倒すためハトのbotを作る 
- [ ] find_elementの探し方ををもっとマシにする

## 導入
1. `src/app.rb`を編集します。
1. `selenium`のドライバを入れます。chromeでmacなら`brew install chromedriver`が楽
1. `bundle install`ローカルにインストールしたいときは`bundle install --path=vendor/bundle`
1. `bundle exec ruby src/app.rb`

使いやすくして行く所存
PRが来るとノーレビューでマスターマージします(ちゃんと読みます)
