#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

# configuration
# @dracula-github-pr-status-repo "api7/cloud"

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $current_dir/utils.sh

get_pr_status() {
    repo=$(get_tmux_option "@dracula-github-pr-status-repo" "api7/cloud")

    /home/linuxbrew/.linuxbrew/bin/gh api graphql -F viewerQuery="repo:$repo state:open is:pr author:@me" -f query='
    fragment pr on PullRequest {
      number
      title
      url
      isDraft
      statusCheckRollup: commits(last: 1) {
        nodes {
          commit {
            statusCheckRollup {
              contexts(first: 100) {
                nodes {
                  ... on CheckRun {
                    name
                    status
                    conclusion
                  }
                }
              }
            }
          }
        }
      }
    }

    query PullRequestStatus($viewerQuery: String!, $per_page: Int = 10) {
      search(query: $viewerQuery, type: ISSUE, first: $per_page) {
        totalCount: issueCount
        edges {
          node {
            ...pr
          }
        }
      }
    }
    ' | /home/nic/bin/gh-pr-query-parser
}

main() {
  echo $(get_pr_status)
  sleep 10
}

# run main driver
main
