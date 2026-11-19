linkParse(){
  # "current" or "tag"
  mode=$1
  # "" for no tag
  tag_name=$2
  cli_args=${*:3}
  echo $mode
  echo $tag_name
  echo $cli_args
}

linkParse $*
