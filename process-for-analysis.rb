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
# 指定要素の配列を抽出
# -------------------------------------------------------------------
# 必要なデータを要素番号で指定して抽出する
# -------------------------------------------------------------------
# 引数：Array(Array) data
# 引数：Array(int) needs
# 返値：Array(Array)  [[1, 3], [4, 6], [7, 9]]
# 利用：pick_at_number([[1,2,3],[4,5,6],[7,8,9]],[0,2])
# -------------------------------------------------------------------
def pick_at_number(data,needs)
  picked = Array.new
  data.each do |value|
    i = 0
    tmp = Array.new
    value.each do |v|
    tmp << v if needs.include?(i)
      i = i + 1
    end
    picked << tmp
  end
  return picked
end

# -------------------------------------------------------------------
# ラベル追加メソッド
# -------------------------------------------------------------------
# 二次元配列を連想配列の配列に変更し、ラベルを追加する。
# -------------------------------------------------------------------
# 引数：data Array(Array) ラベルを追加する元データ
# 引数：header Array(String) ラベル情報
# 返値：Array(Hash)
# 利用：add_label([[1,2],[3,4]],["a","b"])
# -------------------------------------------------------------------
def add_label(data, header)

  added_label = Array.new()

  data.each do |value|
    i = 0
    tmp = Hash.new
    value.each do |v|
      tmp[header[i]] = v
      i = i + 1
    end
    added_label << tmp
  end
  return added_label
end


# -------------------------------------------------------------------
# データの結合
# -------------------------------------------------------------------
# 要素数は同じHash配列の配列の結合
# -------------------------------------------------------------------
# 引数：forword  結合の前方になるデータ
# 引数：backword 結合の後方になるデータ
# 返値：Array(Hash)
# 利用：merge([{"a"=>1,"b"=>2},{"a"=>2,"b"=>3}],[{"c"=>5},{"c"=>6}])
# -------------------------------------------------------------------
def merge(forword,backward)
  merged = Array.new(forword.length){|i| Hash.new}
  forword.length.times do |i|
    merged[i] = forword[i].merge(backward[i])
  end
  return merged
end


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
