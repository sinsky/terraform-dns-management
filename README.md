# Terraform DNS管理

このプロジェクトは、Terraform を使用して Cloudflare DNS レコードを管理します。`sinsky.me`および`sinsky.cc`ドメインの DNS 'A'レコードを管理し、指定された IP アドレスを指すように設定します。

![Terraform](https://img.shields.io/badge/terraform-v1.13+-blue)
![Cloudflare](https://img.shields.io/badge/cloudflare-v5.11+-orange)
![License](https://img.shields.io/badge/license-MIT-green)

## 概要

- **ドメイン**: sinsky.me, sinsky.cc
- **レコードタイプ**: A レコード
- **バックエンド**: PostgreSQL (Neon.tech)
- **CI/CD**: Forgejo Actions

## 技術スタック

- Terraform v1.13.3
- Cloudflare Provider v5.11.0
- PostgreSQL Backend
  - Use Neon.tech for managed PostgreSQL
- Forgejo Actions

## 前提条件

- Terraform CLI
- Cloudflare API トークン
- Cloudflare Account ID

## インストール

### 1. リポジトリのクローン

```bash
git clone https://github.com/sinsky/terraform-dns-management
cd terraform-dns-management
```

### 2. 環境変数の設定

`terraform.tfvars`ファイルを編集して以下の変数を設定：

```bash
cloudflare_zone_id_sinsky_me = "your_zone_id_for_sinsky.me"
cloudflare_zone_id_sinsky_cc = "your_zone_id_for_sinsky.cc"
cloudflare_api_token_sinsky_me = "your_api_token_for_sinsky.me"
cloudflare_api_token_sinsky_cc = "your_api_token_for_sinsky.cc"
```

または、`.envrc`ファイルを作成して環境変数を設定：

```bash
export TERRAFORM_BACKEND_CONN_STR="your_postgresql_connection_string"
export TF_VAR_cloudflare_api_token_sinsky_me="your_api_token_for_sinsky.me"
export TF_VAR_cloudflare_zone_id_sinsky_me="your_zone_id_for_sinsky.me"
export TF_VAR_cloudflare_api_token_sinsky_cc="your_api_token_for_sinsky.cc"
export TF_VAR_cloudflare_zone_id_sinsky_cc="your_zone_id_for_sinsky.cc"
```

## 使用方法

### 初期化

```bash
terraform init -backend-config="conn_str=$TERRAFORM_BACKEND_CONN_STR"
```

### 計画の確認

```bash
terraform plan
```

### 適用

```bash
terraform apply
```

### 破棄

```bash
terraform destroy
```

## プロジェクト構造

```text
.
├── main.tf
├── modules/
│ ├── sinsky.me/       # sinsky.me ドメイン設定
│ │ ├── main.tf      # sinsky.me のリソース定義
│ │ ├── *.yaml       # sinsky.me のDNSレコード定義
│ │ └── variables.tf # sinsky.me の変数宣言
│ └── sinsky.cc/       # sinsky.cc ドメイン設定
├── variables.tf       # ルート変数定義
├── terraform.tfvars   # 変数ファイル(Git管理除外)
└── .terraform-version # Terraform バージョン指定
```

## モジュール構造

各ドメインは独立したモジュールとして管理：

- `modules/sinsky.me`
  - vps domain, mail domain...
- `modules/sinsky.cc`
  - vps domain...

### レコード設定

各モジュールの`*.yaml`ファイルでレコードを定義：

```yaml
unique-key:
  name: "record_name"
  type: "A"
  content: "IP_address"
  proxied: false
  comment: "Record description"
```

## CI/CD

Forgejo Actions で自動化：

- **トリガー**: main ブランチへの push/PR、手動実行
- **ジョブ**:
  - Terraform validate
  - Terraform plan
  - main ブランチのみ: terraform apply

### 必要な Secrets

- `TERRAFORM_BACKEND_CONN_STR`: PostgreSQL 接続文字列
- `CLOUDFLARE_TOKEN_SINSKY_ME`: sinsky.me 用 API トークン
- `CLOUDFLARE_ZONE_ID_SINSKY_ME`: sinsky.me 用 ゾーン ID
- `CLOUDFLARE_TOKEN_SINSKY_CC`: sinsky.cc 用 API トークン
- `CLOUDFLARE_ZONE_ID_SINSKY_CC`: sinsky.cc 用 ゾーン ID

## 開発

### ローカル開発

1. `.envrc`で環境変数を設定
2. `direnv allow`で有効化
3. Terraform コマンドを実行

### 新しいレコードの追加

1. 該当モジュールの`*.yaml`に追加
2. `main.tf`で`locals`のマージを追加
3. `terraform plan`で確認
4. `terraform apply`で適用

### 新しいドメインの追加

1. `modules/`に新しいディレクトリ作成
2. `main.tf`、`variables.tf`を作成
3. ルートの`main.tf`にモジュール呼び出しを追加
4. 必要な API トークンを追加

## セキュリティ

- API トークンは環境変数または Forgejo Secrets で管理
- `terraform.tfvars`は`.gitignore`で除外
- バックエンドは PostgreSQL で暗号化

## トラブルシューティング

### Backend 接続エラー

- `TERRAFORM_BACKEND_CONN_STR`を確認
- Neon.tech の接続文字列が正しいか確認
  - `Connection pooling`を有効化している場合は、末尾に`&options=endpoint%3D<your_region>`を追加する必要がある

### API トークンエラー

- Cloudflare API トークンの権限を確認
- トークンが有効期限切れでないか確認

### Import エラー

既存の DNS レコードを Terraform 管理下に置く場合：

```bash
terraform import 'module.domain.cloudflare_record.records["index"]' zone_id/record_id
```

## Terraform ドキュメント

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## ライセンス

MIT License
