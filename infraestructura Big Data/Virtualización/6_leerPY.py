file_load_cpu = open('usage.log', 'r') 
file_load_cpu_line = file_load_cpu.readlines() 
file_load_cpu.close() 
load= file_load_cpu_line[0] 
print int(load)
