import ping3

def pinghosts(hostnames):

    for hostname in hostnames:
        rtt = ping3.ping(hostname)

        if rtt is not None:
            print(f"Ping naar {hostname} is successful.")

        else:
            print(f"Ping to {hostname} is gefaald.")


servers = ["10.0.8.10", "10.0.8.11", "10.0.8.12","11.0.0.0"]
pinghosts(servers)

#387