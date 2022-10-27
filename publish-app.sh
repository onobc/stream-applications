#!/usr/bin/env bash
SCDIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
SCDIR=$(realpath $SCDIR)
(return 0 2>/dev/null) && sourced=1 || sourced=0
function check_env() {
  eval ev='$'$1
  if [ "$ev" == "" ]; then
    echo "$1 not defined"
    if (( sourced != 0 )); then
      return 1
    else
      exit 1
    fi
  fi
}
if [ "$1" == "" ]; then
  echo "Argument: application-folder required"
  if((sourced > 0)); then
    exit 0
  else
    exit 1
  fi
fi
APP_FOLDER=$1
if [ "$VERSION" == "" ]; then
  VERSION=$($SCDIR/mvn-get-version.sh)
fi
echo "Project Version:$VERSION"
if [[ "$VERSION" == "4."* ]]; then
  JDKS="17"
  if [ "$DEFAULT_JDK" == "" ];then
      DEFAULT_JDK="17"
    fi
else
  if [ "$DEFAULT_JDK" == "" ];then
    DEFAULT_JDK="11"
  fi
  JDKS="8 11 17"
fi

pushd $APP_FOLDER > /dev/null
  pushd apps > /dev/null
    echo "Pushing:$APP_FOLDER/apps"
    BROKERS=$(find * -maxdepth 0 -type d)
    for broker in $BROKERS; do
      project="$APP_FOLDER-$broker"
      set -e
      docker tag "springcloudstream/$project:$VERSION-jdk$DEFAULT_JDK" "springcloudstream/$project:$VERSION"
      if [ "$BRANCH" != "" ]; then
        docker tag "springcloudstream/$app:$VERSION-jdk$DEFAULT_JDK" "springcloudstream/$app:$BRANCH"
        echo "Tagged:springcloudstream/$app:$VERSION-jdk$DEFAULT_JDK as springcloudstream/$app:$BRANCH"
      fi
      docker push "springcloudstream/$project:$VERSION-jdk$DEFAULT_JDK"
      echo "Pushed:springcloudstream/$project:$VERSION-jdk$DEFAULT_JDK"
      docker push "springcloudstream/$project:$VERSION"
      echo "Pushed:springcloudstream/$project:$VERSION"
      for v in $JDKS; do
        docker push "springcloudstream/$project:$VERSION-jdk$v"
        echo "Pushed:springcloudstream/$project:$VERSION-jdk$v"
      done
      set +e
    done
  popd > /dev/null
popd > /dev/null