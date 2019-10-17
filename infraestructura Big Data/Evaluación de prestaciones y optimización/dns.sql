ADD JAR hdfs:///user/uambd02/libs/hadoop-pcap-serde-1.2-SNAPSHOT-jar-with-dependencies.jar;
SET net.ripe.hadoop.pcap.io.reader.class=net.ripe.hadoop.pcap.DnsPcapReader;
DROP TABLE dns_uambd02;
CREATE EXTERNAL TABLE dns_uambd02(ts bigint,src string,dst string,dns_queryid int,dns_qr boolean,dns_opcode string,dns_rcode string,dns_question string,dns_qname string,dns_answer array<string>)
ROW FORMAT SERDE 'net.ripe.hadoop.pcap.serde.PcapDeserializer'
STORED AS INPUTFORMAT 'net.ripe.hadoop.pcap.mr1.io.PcapInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION 'hdfs:/user/uambd02/pcaps/';
