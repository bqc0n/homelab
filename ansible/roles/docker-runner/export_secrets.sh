if [ -e ./.secrets/influxdb2-admin-token ]; then
  echo "influxdb2-admin-token already exists. skipping"
else
  echo "influxdb2-admin-token does not exist. exporting"
  op read "op://Keys/influx-test/credential" >> ./.secrets/influxdb2-admin-token
fi