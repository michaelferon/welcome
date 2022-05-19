SHELL = $$SHELL
SRC = ./src
BLD = ./build
CXX = g++ -std=c++17 -Ofast

target = $(BLD)/a.out
source = $(SRC)/main.cpp

$(target) : $(source)
	$(CXX) $< -o $@


.PHONY : list run time clean
list :
	@echo $$(tput bold)make$$(tput sgr0):
	@echo "  run   -- execute welcome script"
	@echo "  time  -- time welcome script"
	@echo "  clean -- remove  executable"
run : $(target)
	$(BLD)/welcome 'Welcome  Michael'
time : $(target)
	time $(BLD)/welcome 'Welcome  Michael'
clean :
	@rm $(target) && echo 'Target removed.'
