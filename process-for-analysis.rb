#! /usr/bin/env ruby

# process-for-analysis.rb
# データ分析に用いるデータの加工用ライブラリ

# 読み込み用メソッド(配列に入れるだけ)
# input_csv(file_path)

# ヘッダaliasメソッド
# 引数 alias(天気 => weather, 日付 => date)を与えて別名を付ける
# alias_header(alias_array)

# ヘッダ追加メソッド

# データ判別メソッド(yyyy/mm/dd)で始まるものをデータにするなど
# judge_need(regular_expression)

# 要、不要メソッド(0=>true, 1=>false)
# 必要なものをtrueとして、不要なデータを削る

# 木構造作成

# 展開メソッド 1日前のデータを追加するなど。

# 開くファイルを指定(input/#{t+2002}.csv)連番を想定


