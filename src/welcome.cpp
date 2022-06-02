#include <iostream>
#include <string>
#include <sstream>
#include <iomanip>
using namespace std;


string pad(string s, int n, char c) {
	return string((n - s.length()) / 2, c);
}

int main(int argc, char** argv) {
	// Colors.
	string red = "[31m";
	string green = "[32m";
	string normal = "[0m";

	// Input comes in as a single string; convert to string stream.
	string input = string(argv[1]);
	stringstream ss(input);

	// Stream to variables.
	string disk_name, disk_size, used_space, free_space, percent_used_string, window_size_string, cpu, mem;
	ss >> disk_name            //  /dev/disk1s1
	   >> disk_size            //  121G
	   >> used_space           //  31G
	   >> free_space           //  73G
	   >> percent_used_string  //  30%
	   >> window_size_string   //  163
	   >> cpu                  //  48.2
	   >> mem;                 //  79.7

	int window_size = stoi(window_size_string);
	used_space += " Used";  //  31G Used
	free_space += " Free";  //  73G Free
	cpu += "%";             //  48.2%
	mem += "%";             //  79.7%

	string temp = string(percent_used_string);
	temp.pop_back();
	int percent_used = stoi(temp);
	int percent_free = 100 - percent_used;
	string percent_free_string = to_string(percent_free) + "%";

	percent_used /= 2;
	percent_free = 50 - percent_used;

	string block_pad = string((window_size - 50) / 2, ' ');

	string used_space_line = used_space + string(50 - free_space.length() - used_space.length(), ' ') + free_space;
	string ticks_line = red + string(percent_used, '-') + green + string(percent_free, '-') + normal;
	string percent_used_line = percent_used_string + string(50 - percent_free_string.length() - percent_used_string.length(), ' ') + percent_free_string;


	int cpu_max_length = cpu.length() > mem.length() ? cpu.length() : mem.length();
	string cpu_pad = string((window_size - (cpu_max_length + 5)) / 2, ' ');

	cout << pad(disk_name, window_size, ' ') << disk_name << "\n"
	     << pad(disk_size, window_size, ' ') << disk_size << "\n"
		 << block_pad << used_space_line << "\n"
		 << block_pad << ticks_line << "\n"
		 << block_pad << percent_used_line << "\n\n";

	cout << cpu_pad + "CPU: " << setw(cpu_max_length) << cpu << "\n"
		 << cpu_pad + "MEM: " << setw(cpu_max_length) << mem << "\n"
		 << "\n";

	return 0;
}
