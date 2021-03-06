#!/usr/bin/env bash
ORG_REPOS=("jenkins-x/jx-ts-client")
VERSION="$(cat VERSION)"
for org_repo in "${ORG_REPOS[@]}"; do
  OUTDIR="$(jx step git fork-and-clone -b --print-out-dir --dir=$TMPDIR https://github.com/$org_repo)"
  echo "Forked repo to $OUTDIR"
  pushd $OUTDIR
  make all
  git add -N .
  git diff --exit-code
  if [ $? -ne 0 ]; then
    jx create pullrequest -b --push=true --body="upgrade $org_repo client to jx $VERSION" --title="upgrade to jx $VERSION" --label="updatebot"
  fi
  popd
done

exit 0