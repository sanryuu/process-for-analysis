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
# judge_need(regexp)

# 要、不要メソッド(0=>true, 1=>false)
# 必要なものをtrueとして、不要なデータを削る

# 木構造作成

# 展開メソッド 1日前のデータを追加するなど。

# 開くファイルを指定(input/#{t+2002}.csv)連番を想定


# -------------------------------------------------------------------
# データの書き出し (ヘッダあり)
# -------------------------------------------------------------------
# Hash配列の配列のデータの書き出し
# -------------------------------------------------------------------
# 引数：file_path 書き出しファイルのPath
# 引数：data 書き出しデータ
# 返値：なし
# 利用：write_csv("output/1.csv",[{"a"=>1,"b"=>2},{"a"=>2,"b"=>3}])
# -------------------------------------------------------------------
def write_csv(file_path, data)
  CSV.open(file_path, "w") do |csv|

    tmp = Array.new
    data[0].each do |key,val|
      tmp << key
    end
    csv << tmp

    data.each do |out|
      tmp = Array.new
      out.each_pair do |key,val|
        tmp << val
      end
    csv << tmp
    end
  end
end
