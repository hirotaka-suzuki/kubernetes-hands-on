#!/usr/bin/env bash
set -e

# Setup kubectl bash completion
echo "source <(kubectl completion bash)" >> ~/.bashrc

# Setup gcloud bash completion
cat <<EOF >> ~/.bashrc
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/google-cloud-sdk/path.bash.inc' ]; then source '/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/google-cloud-sdk/completion.bash.inc' ]; then source '/google-cloud-sdk/completion.bash.inc'; fi
EOF

# Setup terraform bash completion
terraform -install-autocomplete

# Kube command alias
cat <<EOF >> ~/.bashrc
alias k="kubectl"
alias kc="kubectx"
alias kn="kubens"
complete -o default -F __start_kubectl k
EOF

# Setup gcloud
gcloud --quiet config set project $GCP_PROJECT
gcloud --quiet config set account ${USER}@${DOMAIN}
gcloud --quiet config set compute/region asia-northeast1
gcloud --quiet config set compute/zone asia-northeast1-a
cat ~/.config/gcloud/configurations/config_default

gcloud auth application-default login
gcloud auth login
exec "$@"
