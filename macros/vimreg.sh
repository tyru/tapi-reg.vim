vimreg() {
  if ! which jq >/dev/null 2>&1; then
    echo 'error: jq is not installed.' >&2
    return 1
  fi
  if [ -z "$VIM_TERMINAL" ]; then
    echo 'error: you are running vimreg outside vim terminal' >&2
    return 2
  fi

  local get=false
  local reg='"'
  case "$1" in
    --get|-g) get=true; shift ;;
    --list|-l) get=true; reg='--list'; shift ;;
  esac
  [ $reg != '--list' ] && [ $# -gt 0 ] && reg=$1

  local file
  file=$(mktemp -u)
  if $get; then
    mkfifo "$file"
    __call_tapi_reg get "$reg" "$file"
    cat "$file"
  else
    cat >"$file"
    __call_tapi_reg set "$reg" "$file"
  fi
  rm "$file"
}

__call_tapi_reg() {
  local cmd
  local arg1
  local arg2
  cmd=$(echo  -n "$1" | jq -R --slurp .)
  arg1=$(echo -n "$2" | jq -R --slurp .)
  arg2=$(echo -n "$3" | jq -R --slurp .)
  printf '\e]51;["call","Tapi_reg",[%s,%s,%s]]\x07' "$cmd" "$arg1" "$arg2"
}
