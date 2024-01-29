# dvdrental-dimensional

PostgreSQL のサンプルデータベース dvdrental を Dimensional Model (Star Schema) に変換する

## 使い方
localhost  の PostgreSQL に dvdrental サンプルデータベースをロードしたあとに、 01-init_load.sh を実行する。

### ファイル説明
sql/ ... 各種SQLファイル

01-init_load.sh ... Dimensional Model 作成スクリプト

02-daily_elt.sh ... daily で実行する更新スクリプト SCD type2 を実装

dvdrental_sales_dw.vuerd.json ... VSCode ERD Editor エクステンション用の ER 図

## Note
public.rental テーブルで rental_id が重複しているレコードがあるので payment_date が一番古いものだけ残して重複を除去してます。
