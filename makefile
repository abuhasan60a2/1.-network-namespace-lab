LOG_DIR=logs
SCRIPT_DIR=scripts
LOG_FILE=$(LOG_DIR)/packet_logs.log


#default target
all: setup connectivity capture

#create namespaces and configure interfaces
setup: $(SCRIPT_DIR)/setup.sh
	@echo "Setting up namespaces and interfaces"
	chmod +x $(SCRIPT_DIR)/setup.sh
	bash $(SCRIPT_DIR)/setup.sh

#test connectivity between namespaces
connectivity:
	@echo "Testing connectivity between namespaces"
	ip netns exec ns1 ping -c 7 192.168.1.2

capture:
	@echo "starting packet capture"
	ip netns exec ns1 tcpdump -i veth-ns1 -w $(LOG_FILE) &
	sleep 5
	@echo "capturing done"

clean:
	@echo "Cleaning up"
	ip netns del ns1
	ip netns del ns2
	rm -rf $(LOG_DIR)
	@echo "Cleanup done"