ADD JAR hdfs:///user/uambd02/libs/hadoop-pcap-serde-1.2-SNAPSHOT-jar-with-dependencies.jar;
SET net.ripe.hadoop.pcap.io.reader.class=net.ripe.hadoop.pcap.HttpPcapReader;
select header_host, count(*) as recuento from http_uambd02 where http_request is not NULL group by header_host order by recuento desc;
