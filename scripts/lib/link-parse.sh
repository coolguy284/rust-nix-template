getSubPath(){
  # "current" or "tag"
  mode=$1
  # "" for mode current
  tag_name=$2
  
  
}

linkParse(){
  # "current" or "tag"
  mode=$1
  # "" for mode current
  tag_name=$2
  cli_args=${*:3}
  
  if [ "${#cli_args[@]}" -eq 0 ]; then
    # local link (default)
    return "--out-link" "build/symlinks/$(getSubPath $mode $tag_name)"
  else if [ "${cli_args[0]}" == "--local-link" ]; then
    # local link
  fi
  
  echo $mode
  echo $tag_name
  echo $cli_args
}

linkParse $*
