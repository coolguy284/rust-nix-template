. "${0%/*}/constants.sh"

getSubPath(){
  # "normal" or "github"
  mode=$1
  # "current" or "tag"
  build_out_type=$2
  # "" for build_out_type current
  tag_name=$3
  
  if [ "$build_out_type" == "current" ]; then
    if [ "$mode" == "normal" ]; then
      return "current-normal"
    else if [ "$mode" == "github" ]; then
      return "current-github"
    else
      # https://stackoverflow.com/questions/30078281/raise-error-in-a-bash-script/30078353#30078353
      echo "mode not recognized: $mode"
      exit 1
    fi
  else if [ "$build_out_type" == "tag" ]; then
    if [ "$mode" == "normal" ]; then
      return "tags-normal/$tag_name"
    else if [ "$mode" == "github" ]; then
      return "tags-github/$tag_name"
    else
      # https://stackoverflow.com/questions/30078281/raise-error-in-a-bash-script/30078353#30078353
      echo "mode not recognized: $mode"
      exit 1
    fi
  else
    # https://stackoverflow.com/questions/30078281/raise-error-in-a-bash-script/30078353#30078353
    echo "build_out_type not recognized: $build_out_type"
    exit 1
  fi
}

linkParse(){
  orig_cwd=$1
  repo_root=$2
  # "normal" or "github"
  mode=$3
  # "current" or "tag"
  build_out_type=$4
  # "" for build_out_type current
  tag_name=$5
  cli_args=${*:6}
  
  if [ "${#cli_args[@]}" -eq 0 ] || [ "${cli_args[0]}" == "--local-link" ]; then
    # local link (default)
    return "--out-link" "$repo_root/build/symlinks/$(getSubPath $mode $build_out_type $tag_name)"
  else if [ "${cli_args[0]}" == "--home-link" ]; then
    # home link
    return "--out-link" "~/.cache/git-nix-symlinks/$REPO_PATH/build/symlinks/$(getSubPath $mode $build_out_type $tag_name)"
  else if [ "${cli_args[0]}" == "--custom-path-link" ]; then
    # custom path link
    return "--out-link" "${cli_args[1]}/$(getSubPath $mode $build_out_type $tag_name)"
  else if [ "${cli_args[0]}" == "--custom-link" ]; then
    # custom link
    return "--out-link" "${cli_args[1]}"
  else if [ "${cli_args[0]}" == "--no-link" ]; then
    # no link
    return "--no-link"
  fi
}

linkParse $*
