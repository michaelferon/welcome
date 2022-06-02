SHELL = $$SHELL
SRC = ./src
BIN = ./bin
CXX = g++ -std=c++17 -Ofast -march=native

target = $(BIN)/a.out
source = $(SRC)/welcome.cpp

neofetch_target = $(BIN)/b.out
neofetch_source = $(SRC)/neofetch.cpp


all : $(target) $(neofetch_target)
$(target) : $(source)
	$(CXX) $< -o $@
$(neofetch_target) : $(neofetch_source)
	$(CXX) $< -o $@


.PHONY : list welcome neofetch time clean
list :
	@echo "$$(tput bold)make$$(tput sgr0):" &&
	@echo "  welcome   -- execute welcome script" &&
	@echo "  neofetch  -- execute neofetch script" &&
	@echo "  time      -- time welcome/neofetch scripts" &&
	@echo "  clean     -- remove  executables"
welcome : $(target)
	$(BIN)/welcome 'Welcome  Michael'
neofetch : $(neofetch_target)
	$(BIN)/neofetch
time : $(target)
	time $(BIN)/welcome 'Welcome  Michael'
	@echo
	time $(BIN)/neofetch
clean :
	rm $(target) $(neofetch_target)
	@echo 'Targets removed.'
