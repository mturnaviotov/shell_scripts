# DevOps Preparation:

# Docker
1.1 add metrics publishing
```
# cat /etc/docker/daemon.json
{
  "metrics-addr" : "192.168.103.10:2000"
}
```
1.2 restart docker daemon
```sudo service restart docker```

# Teamcity
Read [Docker container Official guide](teamcity-docker-images/dockerhub/teamcity-server/README.md) at master 'JetBrains/teamcity-docker-images'

2.1 Prepare folders on docker host
```
sudo mkdir /var/lib/teamcity
sudo mkdir /var/log/teamcity
# Allow write for Teamcity PID 1000 for folders on docker host
sudo chown 1000:1000 /var/log/teamcity
sudo chown 1000:1000 /var/lib/teamcity
```

2.2 Create TC container with auto restart policy
```
sudo docker run -d --name teamcity-server0 --hostname teamcity-server0 -v /var/lib/teamcity:/data/teamcity_server/datadir -v /var/log/teamcity:/opt/teamcity/logs -p 8888:8111 -e TEAMCITY_SERVER_MEM_OPTS="-Xmx2g -XX:MaxPermSize=270m -XX:ReservedCodeCacheSize=640m" --restart unless-stopped jetbrains/teamcity-server
```

2.3 Open dockerhost:8888 by web browser and follow web guide instructions (EULA accept, local sql database use, admin creds enter, etc)

2.4 Teamcity Linux agent
2.5 Script for installing
```
folderList=("/var/lib/teamcity_agent/" "/var/lib/teamcity_agent/buildagent" "/var/lib/teamcity_agent/buildagent/tools" "/var/lib/teamcity_agent/buildagent/work" "/var/lib/teamcity_agent/buildagent/system" "/var/lib/teamcity_agent/buildagent/temp" "/var/lib/teamcity_agent/buildagent/plugins" "/var/lib/teamcity_agent/tools")
for folder in ${folderList[@]}; do
  mkdir $folder
done
sudo chown 1000:1000 -R /var/lib/teamcity_agent/
sudo docker pull  jetbrains/teamcity-agent
sudo docker run --name teamcity-agent0 --hostname teamcity-agent0 -d -e SERVER_URL=http://dockerhost:8888/ -u 1000 --restart unless-stopped -v /var/lib/teamcity_agent/conf:/data/teamcity_agent/conf -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/teamcity_agent/work:/opt/buildagent/work -v /var/lib/teamcity_agent/temp:/opt/buildagent/temp -v /var/lib/teamcity_agent/tools:/opt/buildagent/tools -v /var/lib/teamcity_agent/plugins:/opt/buildagent/plugins -v /var/lib/teamcity_agent/system:/opt/buildagent/system jetbrains/teamcity-agent
```
After that - connect agent to server and authorize it as usually via teamcity Web UI

# Prometheus
3.1 Create config /var/lib/prometheus/prometheus.yml
```
# my global config
global:
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).
 
  # Attach these labels to any time series or alerts when communicating with
  # external systems (federation, remote storage, Alertmanager).
  external_labels:
      monitor: 'codelab-monitor'
 
# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first.rules"
  # - "second.rules"
 
# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'
 
    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.
 
    static_configs:
      - targets: ['localhost:9090']
 
  - job_name: 'docker'
         # metrics_path defaults to '/metrics'
         # scheme defaults to 'http'.
 
    static_configs:
      - targets: [localhost:2000]
```
3.2 Create container
```docker run -d -p 9100:9090 --name prometheus --hostname prometheus0 --restart unless-stopped -v /var/lib/prometheus:/etc/prometheus prom/prometheus```
3.3 Open Prometheus Web UI dockerhost:9100

# Grafana
4.1 Create container
```docker run -d --name=grafana0 --hostname grafana0 --restart unless-stopped -p 9200:3000 grafana/grafana-oss```
4.2 Go to Web UI on dockerhost:9200, enter admin/admin as default creds and enter new password
4.3 Now you can set up dashboards, alerts, etc.
