ADD JAR hdfs:///user/uambd02/libs/hadoop-pcap-serde-1.2-SNAPSHOT-jar-with-dependencies.jar;
select src, dst, src_port, dst_port, protocol, sum(len) as bytes, count(*) from pcaps_uambd02 group by src, dst, src_port, dst_port, protocol  order by bytes desc;

