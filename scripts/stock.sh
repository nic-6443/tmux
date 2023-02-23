#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

# configuration
# @dracula-stock-code "sz600519"

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $current_dir/utils.sh

get_stock_stats() {
    code=$(get_tmux_option "@dracula-stock-code" "sz600519")
    output=$(curl --noproxy '*' http://qt.gtimg.cn/q\=$code -s | awk -F'=' '{print $2}' | awk -F'~' '{print $33}')
    echo "$output"%
}

main() {
  echo $(get_stock_stats)
  sleep 900
}

# run main driver
main
