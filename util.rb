#! /usr/bin/env ruby

# 分析に利用したいその他メソッド

require 'date'

# -------------------------------------------------------------------
# 日付検索メソッド
# -------------------------------------------------------------------
# 必要な日付を文字列型で返却する
# -------------------------------------------------------------------
# 引数：String date_str 基準になる日付
# 引数：String  split_char 区切り文字
# 引数：Integer margin 日数差
# 引数：String  format フォーマット(date型に従う)
# 返値：String "2012-04-29"
# 利用：search_day("2012/05/04","/",-1,"%Y/%m/%d")
# -------------------------------------------------------------------
def search_day(date_str,split_char,margin,format)
  d = date_str.split(split_char)

  day = Date.new(d[0].to_i,d[1].to_i,d[2].to_i)
  day = day + margin
  return day.strftime(format)
end

