# isucon-kit

## Prerequisites

- rsync
- Go (`deploy.sh` が `make app/build` を実行するため)

## Setup

### 1. Login as root user on remote host

`root`ユーザとしてログインできるようにする。

1. `isucon`ユーザとしてログイン

```sh
$ ssh isucon@{リモートホストIP}
```

2. `root`ユーザの`~/.ssh/authorized_keys`に公開鍵をコピー

```sh
$ sudo cp ~/.ssh/authorized_keys /root/.ssh/authorized_keys
```

### 2. Configure remote host

`~/.ssh/config`にホスト`isuconapp`と `isucondb` エイリアスを登録。

```
Host isuconapp
  Hostname <ホストIP>
  User root
  Port 22
  IdentityFile ~/.ssh/id_ed25519
Host isucondb
  Hostname <ホストIP>
  User root
  Port 22
  IdentityFile ~/.ssh/id_ed25519
```

### 3. Pull remote files

リモートホストのアプリケーション、環境変数、Nginx / sysctl / PowerDNS / MySQL 設定ファイルをプルしてくるセットアップシェルスクリプトを実行。

```sh
$ sh ./pull.sh
$ sh ./install_tools.sh
```

### 4. Fix to restart application server

Makefile の app/restart と app/build の両方を修正する。app/build は `deploy.sh` から呼ばれるため、アプリの言語・ディレクトリ・バイナリ名に合わせて必ず直す。

### 5. Set secrets in GitHub Actions

GitHub Actions の Secrets に Hostname と SSH キーの秘密鍵をセットする

```
APP_HOST_NAME=
DB_HOST_NAME=
SSH_KEY=
```

## Deploy

ファイルの変更を Commit & Push し、PR を作成すると自動でデプロイされる

アプリケーションのビルド（`make app/build`）は `deploy.sh` の中で実行されるため、ビルド済みバイナリをコミットする必要はない。

## Analyze

Pull Request か Issue で下記のコメントをすると、アクセスログ解析とスロークエリログ解析が開始し、結果が出力させる

```
/analyze
```

## Agent Tasks

```
/summarize-issues # リポジトリ内のIssueをまとめる
/parallel-plan # 作成したIssueの並行作業プランを可視化する
```