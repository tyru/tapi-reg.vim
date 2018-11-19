vimreg() {
  local get=false
  case "$1" in
    --get) get=true; shift ;;
    --set) shift ;;
  esac

  local reg='"'
  [ $# -gt 0 ] && reg=$1

  if $get; then
    printf '\e]51;["call","Tapi_reg",["get",%s]]\x07' "$reg"
    cat
    return
  fi

  content=$(cat)
  # convert to JSON string
  reg="\"${reg//\"/\\\"}\""
  content="\"${content//\"/\\\"}\""
  printf '\e]51;["call","Tapi_reg",["set",%s,%s]]\x07' "$reg" "$content"
}
