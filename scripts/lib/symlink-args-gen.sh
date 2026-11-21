. "${0%/*}/constants.sh"

getSubPath(){
  # "normal" or "github"
  mode=$1
  # "current" or "tag"
  buildOutType=$2
  # "" for buildOutType current
  tagName=$3
  
  if [ "$buildOutType" == "current" ]; then
    if [ "$mode" == "normal" ]; then
      return "current-normal"
    else if [ "$mode" == "github" ]; then
      return "current-github"
    else
      # https://stackoverflow.com/questions/30078281/raise-error-in-a-bash-script/30078353#30078353
      echo "mode not recognized: $mode"
      exit 1
    fi
  else if [ "$buildOutType" == "tag" ]; then
    if [ "$mode" == "normal" ]; then
      return "tags-normal/$tagName"
    else if [ "$mode" == "github" ]; then
      return "tags-github/$tagName"
    else
      # https://stackoverflow.com/questions/30078281/raise-error-in-a-bash-script/30078353#30078353
      echo "mode not recognized: $mode"
      exit 1
    fi
  else
    # https://stackoverflow.com/questions/30078281/raise-error-in-a-bash-script/30078353#30078353
    echo "buildOutType not recognized: $buildOutType"
    exit 1
  fi
}

linkParse(){
  # "normal" or "github"
  mode=$1
  # "current" or "tag"
  buildOutType=$2
  # "" for buildOutType current
  tagName=$3
  cliArgs=${*:4}
  
  if [ "${#cliArgs[@]}" -eq 0 ] || [ "${cliArgs[0]}" == "--local-link" ]; then
    # local link (default)
    return "--out-link" "./build/symlinks/$(getSubPath $mode $buildOutType $tagName)"
  else if [ "${cliArgs[0]}" == "--home-link" ]; then
    # home link
    return "--out-link" "~/.cache/git-nix-symlinks/$REPO_PATH/build/symlinks/$(getSubPath $mode $buildOutType $tagName)"
  else if [ "${cliArgs[0]}" == "--custom-path-link" ]; then
    # custom path link
    return "--out-link" "${cliArgs[1]}/$(getSubPath $mode $buildOutType $tagName)"
  else if [ "${cliArgs[0]}" == "--custom-link" ]; then
    # custom link
    return "--out-link" "${cliArgs[1]}"
  else if [ "${cliArgs[0]}" == "--no-link" ]; then
    # no link
    return "--no-link"
  fi
}

linkParse $*
