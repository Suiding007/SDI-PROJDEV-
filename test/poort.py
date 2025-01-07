import telnetlib

def is_port_open(host, port):
    try:
        with telnetlib.Telnet(host, port, timeout=3):
            return True
    except:
        return False

def check_port(host, port):

    if is_port_open(host, port) == True:
        print(f"De poort {port} op {host} is open.")
    else:
        print(f"De poort {port} op {host} is gesloten of onbereikbaar.")

def check_range_from_string(host_ports):
    # Loop door elke host:portstring
    for host_port in host_ports:
        
        host, ports = host_port.split(":")
        # Split de poorten die gescheiden zijn door een komma
        ports = ports.split(",")
        
        # Loop door de poorten voor deze host
        print(f"\nControleer poorten op {host}:")
        for port in ports:
            check_port(host, int(port))

host_ports_list = ["10.0.8.17:8080,22", "10.0.8.14:80", ]
check_range_from_string(host_ports_list)
