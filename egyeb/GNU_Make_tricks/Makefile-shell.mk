

# $(shell mkdir -p $(ALL_MODULES))


define my_important_task =
	echo "kutya"
	echo "marha"
endef

my-important-task: ; $(value my_important_task)

.ONESHELL: