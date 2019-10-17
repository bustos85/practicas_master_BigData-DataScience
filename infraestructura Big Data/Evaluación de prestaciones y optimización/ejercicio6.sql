ADD JAR hdfs:///user/uambd02/libs/hadoop-pcap-serde-1.2-SNAPSHOT-jar-with-dependencies.jar;
SET net.ripe.hadoop.pcap.io.reader.class=net.ripe.hadoop.pcap.DnsPcapReader;
select dns_qname, count(*) as recuento from dns_uambd02 where dns_qr=true group by dns_qname order by recuento desc;
