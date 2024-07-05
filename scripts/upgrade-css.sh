CS_SHARP_URL=$(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/roflmuffin/CounterStrikeSharp/releases/latest | jq -c '.assets.[] | select( .name | test("^counterstrikesharp-with-runtime-build-[0-9]+-linux-[a-zA-Z0-9]+.zip$")) | .browser_download_url')

echo $CS_SHARP_URL

# TODO update Dockerfile with sed
