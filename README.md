# Kubernetes Hands-on

社内勉強会用のDockerコンテナによる Kubernetes 操作環境。
Kubernetes クラスタは Google Kubernetes Engine (GKE) を使用します。

## How to Use

### Terraform

サブネットとGKEのリージョナルクラスタを作成します。

`terraform/variable.tf` を編集して必要な情報を入力してください。
諸般の事情から、VPCを作成済みの想定としているため、VPCのリンクあるいは、
VPC作成の resource を必要に応じて追加してください。

`var.common.user_prefix` は、GKEクラスタ名として使用するため、記号はハイフンのみ使用できます。

### start.sh

Docker イメージをビルドして起動します。
本シェルスクリプト実行時に、必要な情報の入力が求められるので、入力してください。
* GCP Porject
* User Name (GCP Project 使用ユーザに対応するメールアドレスのローカル部。コンテナのローカルユーザ名としても使用する)
* Domain (GCP Project 使用ユーザに対応するメールアドレスのドメイン)
* Password (コンテナ内で使用するユーザパスワード)


#### Mac でのマウント権限の設定

以下のようなエラーが出た場合は、エラーの指示にしたがって Docker for Mac の File Sharing 設定に `terraform` ディレクトリを追加してください。
```
docker: Error response from daemon: Mounts denied:
The path /path/to/kubernetes-hands-on/terraform
is not shared from OS X and is not known to Docker.
You can configure shared paths from Docker -> Preferences... -> File Sharing.
See https://docs.docker.com/docker-for-mac/osxfs/#namespaces for more info.
```
