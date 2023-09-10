#! /bin/bash

## Deploys the docker app with a color based on hostname

[[ "root" != $(whoami) ]] && {
  echo "Must be run as root. Exiting.";
  exit;
}

export COLOR="$(hostname)"
apt  install -y docker.io
docker run --name colors -d --rm -e COLOR="$COLOR" -h docker.$(hostname) -e PORT=9000 -p 9000:9000 ovhlearningcenter/flask-colors:0.2

