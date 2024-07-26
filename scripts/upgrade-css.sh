CS_SHARP_URL=$(curl -sSL \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/roflmuffin/CounterStrikeSharp/releases/latest | jq -c '.assets.[] | select( .name | test("^counterstrikesharp-with-runtime-build-[0-9]+-linux-[a-zA-Z0-9]+.zip$")) | .browser_download_url')

ARG_REPLACE_STR="ARG CS_SHARP_URL="
REPLACEMENT_STR="${ARG_REPLACE_STR}${CS_SHARP_URL}"

sed -i '' "s|${ARG_REPLACE_STR}.*|${REPLACEMENT_STR}|" Dockerfile
