LOG_DIR=logs
SCRIPT_DIR=scripts
LOG_FILE=$(LOG_DIR)/packet_logs.log


#default target
all: setup create_log connectivity capture

#create namespaces and configure interfaces
setup: $(SCRIPT_DIR)/setup.sh
	@echo "Setting up namespaces and interfaces"
	chmod +x $(SCRIPT_DIR)/setup.sh
	bash $(SCRIPT_DIR)/setup.sh

create_log:
	@if [ ! -d $(LOG_DIR) ]; then \
		echo "Creating log directory"; \
		mkdir -p $(LOG_DIR); \
	fi
	@if [ ! -f $(LOG_FILE) ]; then \
		echo "Creating packet logs file"; \
		touch $(LOG_FILE); \
	fi

#test connectivity between namespaces
connectivity:
	@echo "Testing connectivity between namespaces"
	ip netns exec ns1 ping -c 3 192.168.1.2

capture:
	@echo "starting packet capture"
	
	ip netns exec ns1 tcpdump -i veth-ns1  -l -w $(LOG_FILE)  &
	sleep 10
	@echo "capturing done"

clean:
	@echo "Cleaning up"
	ip netns del ns1
	ip netns del ns2
	rm -rf $(LOG_DIR)
	@echo "Cleanup done"