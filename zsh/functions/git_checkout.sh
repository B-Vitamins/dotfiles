# Function to clone and checkout the latest branch from a compressed mirror
function git_checkout {
  local repo_name="$1"
  local mirror_dir="$HOME/library/mirrors/repos/${repo_name}.git.tar.gz"
  local checkout_dir="$HOME/library/mirrors/checkout/${repo_name}"

  if [ -z "$repo_name" ]; then
    echo "Usage: git-checkout <repository name>"
    return 1
  fi

  if [ ! -f "$mirror_dir" ]; then
    echo "Repository not found: $repo_name"
    return 1
  fi

  mkdir -p "$checkout_dir"
  tar -xzf "$mirror_dir" -C "$checkout_dir" --strip-components=1

  cd "$checkout_dir"
  local latest_branch=$(git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short)' | head -n 1)
  git checkout "$latest_branch"

  echo "Checked out to $latest_branch in $checkout_dir"
}
