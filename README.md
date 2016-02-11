# hadoop-spatial-framework-docker
Quickly build arbitrary size Hadoop cluster based on Docker includes tools for analysis spatial data.
------
Core of this project is based on [krejcmat/hadoop-docker](https://github.com/krejcmat/hadoop-spatial-framework-docker/blob/master/README.md) images. Please check details on mentioned site. Dockerfile sources of this project extends Hadoop docker ([krejcmat/hadoop-docker](https://github.com/krejcmat/hadoop-spatial-framework-docker/blob/master/README.md)) images by layers with: Hive, [geometry-api-java](https://github.com/Esri/geometry-api-java), [spatial-framework-for-hadoop](https://github.com/Esri/spatial-framework-for-hadoop) and [Hive-JSON-Serde](https://github.com/Esri/spatial-framework-for-hadoop/wiki/Hive-JSON-SerDe). The Spatial Framework for Hadoop allows developers and data scientists to use the Hadoop data processing system for spatial data analysis.

######Version of products
| system          | version    | 
| ----------------|:----------:| 
| Hive            |1.2.1       |


######See file structure of project 
```
$ tree

.
├── build-image.sh
├── gitcommit.sh
├── hadoop-spatial-framework-base
│   ├── Dockerfile
│   └── files
│       ├── bashrc
│       ├── hadoop-env.sh
│       ├── hive-env.sh
│       └── ssh_config
├── hadoop-spatial-framework-master
│   ├── Dockerfile
│   └── files
│       ├── hadoop
│       │   ├── configure-slaves.sh
│       │   ├── core-site.xml
│       │   ├── hdfs-site.xml
│       │   ├── mapred-site.xml
│       │   ├── run-wordcount.sh
│       │   ├── start-hadoop.sh
│       │   ├── start-ssh-serf.sh
│       │   ├── stop-hadoop.sh
│       │   └── yarn-site.xml
│       └── hive
│           ├── configure-hive.sh
│           ├── hive-config.sh
│           └── hive-site.xml
├── hadoop-spatial-framework-slave
│   ├── Dockerfile
│   └── files
│       ├── hadoop
│       │   ├── core-site.xml
│       │   ├── hdfs-site.xml
│       │   ├── mapred-site.xml
│       │   ├── start-ssh-serf.sh
│       │   └── yarn-site.xml
│       └── hive
│           ├── configure-hive.sh
│           ├── hive-config.sh
│           └── hive-site.xml
├── README.md
├── rebuild_hub.sh
├── resize-cluster.sh
└── start-container.sh


```

###Usage
####1] Clone git repository
```
$ git clone https://github.com/krejcmat/hadoop-spatial-framework-docker.git
$ cd hadoop-spatial-framework-docker
```

####2] Get docker images 
Two options how to get images are available. By pulling images directly from Docker official repository or build from Dockerfiles and sources files(see Dockerfile in each hadoop-spatial-framework-* directory). Builds on DockerHub are automatically created by pull trigger or GitHub trigger after update Dockerfiles. Triggers are setuped for tag:latest. Below is example of stable version krejcmat/hadoop-spatial-framework-<>:0.1. Version krejcmat/hadoop-spatial-framework-<>:latest is compiled on DockerHub from master branche on GitHub.

######a) Download from Docker hub
```
$ docker pull krejcmat/hadoop-spatial-framework-master:latest
$ docker pull krejcmat/hadoop-spatial-framework-slave:latest
```

######b)Build from sources(Dockerfiles)
Firstly build Hadoop dockere images [krejcmat/hadoop-docker](https://github.com/krejcmat/hadoop-docker).
The first argument of the script for bulilds is must be folder with Dockerfile. Tag for sources is **latest**
```
$ ./build-image.sh hadoop-spatial-framework-base
```

######Check images
```
$ docker images

krejcmat/hadoop-spatial-framework-slave    latest              147c9982fb6e        Less than a second ago   780.1 MB
krejcmat/hadoop-spatial-framework-master   latest              379d2b21c2d4        4 seconds ago            995.6 MB
krejcmat/hadoop-spatial-framework-base     latest              500a6dc95305        4 minutes ago            779.9 MB
```

####3] Initialize Hadoop (master and slaves)
For starting Hadoop cluster see documentation of [krejcmat/hadoop-docker](https://github.com/krejcmat/hadoop-docker/blob/master/README.md#3-initialize-hadoop-master-and-slaves).

If Hadoop is runnig go to next step.

####4] Start Hive
```
$ hive
```



####Example of usage ST_Geometry package in Hive

```
issue https://github.com/Esri/gis-tools-for-hadoop/issues/26
add jar /root/gis-tools-for-hadoop/samples/lib/esri-geometry-api.jar;
add jar /root/gis-tools-for-hadoop/samples/lib/spatial-sdk-hadoop.jar;

create temporary function ST_Point as 'com.esri.hadoop.hive.ST_Point';
create temporary function ST_Contains as 'com.esri.hadoop.hive.ST_Contains';
drop table earthquakes;
drop table counties;

CREATE EXTERNAL TABLE earthquakes (earthquake_date STRING, latitude DOUBLE, longitude DOUBLE, depth DOUBLE, magnitude DOUBLE,
    magtype string, mbstations string, gap string, distance string, rms string, source string, eventid string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

CREATE EXTERNAL TABLE counties (Area string, Perimeter string, State string, County string, Name string, BoundaryShape binary)
ROW FORMAT SERDE 'com.esri.hadoop.hive.serde.JsonSerde'
STORED AS INPUTFORMAT 'com.esri.json.hadoop.EnclosedJsonInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat';

LOAD DATA INPATH '/earthquake-demo/earthquakes.csv' OVERWRITE INTO TABLE earthquakes;
LOAD DATA INPATH '/earthquake-demo/california-counties.json' OVERWRITE INTO TABLE counties;

SELECT counties.name, count(*) cnt FROM counties
JOIN earthquakes
WHERE ST_Contains(counties.boundaryshape, ST_Point(earthquakes.longitude, earthquakes.latitude))
GROUP BY counties.name
ORDER BY cnt desc;
```
!!issue https://github.com/Esri/gis-tools-for-hadoop/issues/26

####Sources & references

[Hive admin manual](https://cwiki.apache.org/confluence/display/Hive/AdminManual+Configuration#AdminManualConfiguration-hive-site.xmlandhive-default.xml.template)

[Hive, configuratin and properties](https://cwiki.apache.org/confluence/display/Hive/Configuration+Properties)

[how-to-convert-arcgis-server-json-to-geojson](http://gis.stackexchange.com/questions/13029/how-to-convert-arcgis-server-json-to-geojson)

[how-to-process-geojson-data-and-create-hive-table-for-spatial-analysis](http://gis.stackexchange.com/questions/113619/how-to-process-geojson-data-and-create-hive-table-for-spatial-analysis)

[how-to-load-spatial-data-using-the-hadoop-gis-framework](http://stackoverflow.com/questions/27147274/how-to-load-spatial-data-using-the-hadoop-gis-framework)

[Esri/geojson-utils](https://github.com/Esri/geojson-utils)

[load data example](https://docs.datastax.com/en/datastax_enterprise/4.6/datastax_enterprise/ana/anaAnalyzeGIS.html)

[Converting geometries between GeoJSON, esri JSON, and esri Python](https://geonet.esri.com/thread/90950)

[how-to-load-spatial-data-using-the-hadoop-gis-framework](http://stackoverflow.com/questions/27147274/how-to-load-spatial-data-using-the-hadoop-gis-framework)


[Geospatial Data Analysis in Hadoop!!!!!!!!!!!!!!!!!!!IMPORT DATA](https://community.hortonworks.com/articles/5129/geospatial-data-analysis-in-hadoop.html)

[Hive cofiguration](https://cwiki.apache.org/confluence/display/Hive/AdminManual+Configuration)

[List of DATABASES](http://usefulstuff.io/big-data/)

[HDFS cheatsheat](https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/FileSystemShell.html#mkdir)

[Hadoop Toolbox: When to Use What](http://www.smartdatacollective.com/mtariq/120791/hadoop-toolbox-when-use-what)


