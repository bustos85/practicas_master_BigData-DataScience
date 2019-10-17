ADD JAR hdfs:///user/uambd02/libs/hadoop-pcap-serde-1.2-SNAPSHOT-jar-with-dependencies.jar;
select ts, sum(len*8) as bits from pcaps_uambd02 group by ts order by bits desc;

