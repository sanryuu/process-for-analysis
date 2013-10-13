#! /usr/bin/env ruby

#= データ分析に用いるデータの加工用ライブラリ
#
# データ分析に用いるデータの加工用ライブラリ
# 二重配列とHashの配列の操作を主に行う

#
#== 指定要素の配列を抽出(番号指定)
#
# 必要なデータを要素番号で指定して抽出する
#
# 利用::pick_at_number([[1,2,3],[4,5,6],[7,8,9]],[0,2])
# 返値::Array(Array)  [[1,3], [4,6], [7,9]]
#
# 引数::Array(Array) data
# 引数::Array(int) needs
#
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

#
#== 指定要素の配列を抽出(要素名指定)
#
# 必要なデータを要素名で指定して抽出する
#
# 利用::pick_at_header([{"a"=>1,"b"=>2},{"a"=>2,"b"=>3}],["a"])
# 返値::Array(Hash)  [{"a"=>1}, {"a"=>2}]
#
# 引数::Array(Array) data
# 引数::Array(int) needs
#
def pick_at_header(data,needs)
  picked = Array.new
  data.each do |value|
    tmp = Hash.new
    value.each_pair do |k,v|
      tmp[k] = v if needs.include?(k)
    end
    picked << tmp
  end
  return picked
end


#
#== 1行目をラベルにする
#
# ラベルが1行目に含まれているデータのラベルを
# 連想配列のキーとして保存
#
# 利用::add_label_from_first([["a","b"],[3,4],[5,6]])
# 返値::Array(Hash) [{"a"=>3, "b"=>4}, {"a"=>5, "b"=>6}]
#
# 引数::data Array(Array) ラベルを含む元データ
#
def add_label_from_first(data)

  reject_heade = Array.new

  length = data.length
  for i in 1...length
    reject_heade << data[i]
  end

  header = data[0]

  return add_label(reject_heade,header)

end


#
#== ラベル追加メソッド
#
# 二次元配列を連想配列の配列に変更し、ラベルを追加する。
#
# 利用::add_label([[1,2],[3,4]],["a","b"])
# 返値::Array(Hash) [{:a=>1, :b=>2}, {:a=>3, :b=>4}]
#
# 引数::data Array(Array) ラベルを追加する元データ
# 引数::header Array(String) ラベル情報
#
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


#
#== データの結合
#
# 要素数は同じHash配列の配列の結合
#
# 返値::Array(Hash) [{:a=>1, :b=>2, :c=>5}, {:a=>2, :b=>3, :c=>6}]
# 利用::merge([{a: 1,b: 2},{a: 2,b: 3}],[{c: 5},{c: 6}])
#
# 引数::forword  結合の前方になるデータ
# 引数::backword 結合の後方になるデータ
#
def merge(forword,backward)
  merged = Array.new(forword.length){|i| Hash.new}
  forword.length.times do |i|
    merged[i] = forword[i].merge(backward[i])
  end
  return merged
end


#
#== データの書き出し
#
# 配列のデータの書き出し
# Array(Hash),Array(Array)の2種類の配列に対応
#
# 利用::write_csv("output/1.csv",[{a: 1, b: 2},{a: 2, b: 3}])
# 利用::write_csv("output/1.csv",[[1,2],[2,3]])
# 返値::なし
#
# 引数::String file_path 書き出しファイルのPath
# 引数::Array(Hash) data 書き出しデータ
#
def write_csv(file_path, data)

  if data.class == Array
    if data[0].class == Array
      write_array_to_csv(file_path, data)
    elsif data[0].class == Hash
      write_hash_to_csv(file_path, data)
    else
      print "対応していない型です。\n"
    end
  else
    print "配列以外の型には対応していません\n"
  end
end

#
#== データの書き出し (ヘッダあり)
#
# Hash配列の配列のデータの書き出し
#
# 利用::write_hash_to_csv("output/1.csv",[{"a"=>1,"b"=>2},{"a"=>2,"b"=>3}])
# 返値::なし
#
# 引数::String file_path 書き出しファイルのPath
# 引数::Array(Hash) data 書き出しデータ
#
def write_hash_to_csv(file_path, data)

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

#
#== データの書き出し
#
# 配列の配列のデータの書き出し
#
# 利用::write_array_to_hash_csv("output/1.csv",[[1,2],[2,3]])
# 返値::なし
#
# 引数::String file_path 書き出しファイルのPath
# 引数::Array(Hash) data 書き出しデータ
#
def write_array_to_csv(file_path, data)

  CSV.open(file_path, "w") do |csv|

    data.each do |out|
      tmp = Array.new
      out.each do |val|
        tmp << val
      end
    csv << tmp
    end
  end
end

#
#== 欠損値埋め
#
# 配列の配列、Hash配列の配列における欠損値に対して
# 指定した値を代入する
#
# 利用::fill_in_missing([{a: 2,b: nil},{a: nil, b: 3}],0)
# 返値::[{:a=>2, :b=>0}, {:a=>0, :b=>3}]
# 利用::fill_in_missing([[nil,2],[3,nil]],0)
# 返値::[[0, 2], [3, 0]]
#
# 引数::Array(Array) data 加工元データ
# 引数::Object sub        埋めるデータ
#
def fill_in_missing(data, sub)

  if data.class == Array
    if data[0].class == Array
      fill_in_array_missing(data,sub)
    elsif data[0].class == Hash
      fill_in_hash_missing(data,sub)
    else
      print "対応していない型です。\n"
    end
  else
    print "配列以外の型には対応していません\n"
  end
end

#
#== 欠損値埋め(配列)
#
# 配列の配列における欠損値に対して指定した値を代入する
#
# 利用::fill_in_array_missing([[nil,2],[3,nil]],0)
# 返値::[[0, 2], [3, 0]]
#
# 引数::Array(Array) data 加工元データ
# 引数::Object sub        埋めるデータ
#
def fill_in_array_missing(data, sub)

  filled = Array.new
  data.each do |line|
    tmp = Array.new
    line.each do |entity|
      if entity.nil?
        tmp << sub
      else
        tmp << entity
      end
    end
     filled << tmp
  end
  return filled
end

#
#== 欠損値埋め(Hash配列)
#
# Hash配列の配列における欠損値に対して指定した値を代入する
#
# 利用::fill_in_hash_missing([{a: 2,b: nil},{a: nil, b: 3}],0)
# 返値::{:a=>2, :b=>0}, {:a=>0, :b=>3}]
#
# 引数::Array(Hash) data 加工元データ
# 引数::Object sub        埋めるデータ
#
def fill_in_hash_missing(data, sub)

  filled = Array.new
  data.each do |line|
    tmp = Hash.new
    line.each do |key,entity|

      if entity.nil?
        tmp[key] = sub
      else
        tmp[key] = entity
      end
    end
     filled << tmp
  end
  return filled
end
