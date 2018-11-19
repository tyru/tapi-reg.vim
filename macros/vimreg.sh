vimreg() {
  local get=false
  case "$1" in
    --get) get=true; shift ;;
    --set) shift ;;
  esac

  local reg='"'
  [ $# -gt 0 ] && reg=$1

  if $get; then
    fifo=$(mktemp -u)
    mkfifo "$fifo"
    printf '\e]51;["call","Tapi_reg",["get",%s,%s]]\x07' \
      "$(to_json_string "$reg")" "$(to_json_string "$fifo")"
    cat "$fifo"
    rm "$fifo"
  else
    content=$(cat)
    printf '\e]51;["call","Tapi_reg",["set",%s,%s]]\x07' \
        "$(to_json_string "$reg")" "$(to_json_string "$content")"
  fi
}

to_json_string() {
  echo "\"${1//\"/\\\"}\""
}
