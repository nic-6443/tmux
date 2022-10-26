#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

# configuration
# @dracula-aria2-server "http://127.0.0.1:6800"
# @dracula-aria2-token "YOUR_TOKEN"
# @dracula-aria2-refresh-rate 3

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $current_dir/utils.sh

get_progress_function() {
  case $(uname -s) in
  Linux | Darwin)
    # storing the hostname/IP in the variable PINGSERVER, default is google.com
    aria2_server=$(get_tmux_option "@dracula-aria2-server" "127.0.0.1:6800")
    aria2_token=$(get_tmux_option "@dracula-aria2-token" "")
    resp=$(curl "$aria2_server/jsonrpc" \
      --data-raw $'{"jsonrpc":"2.0","method":"aria2.tellActive","id":"dracula-aria2","params":["token:'$aria2_token'",["gid","totalLength","completedLength"]]}')
    total_length=$(echo $resp | jq '[.result[] | .totalLength | tonumber] | add')
    pencent=$(echo $resp | jq "[.result[] | .completedLength | tonumber] | add / $total_length * 100 | floor")
    echo "Aria2 $pencent%"
    ;;

  CYGWIN* | MINGW32* | MSYS* | MINGW*)
    # TODO - windows compatability
    ;;
  esac
}

main() {

  echo $(get_progress_function)
  RATE=$(get_tmux_option "@dracula-aria2-refresh-rate" 3)
  sleep $RATE
}

# run main driver
main
