#!/usr/bin/env python

import sys
import subprocess

def main():
	while True:
		# Easy Python 2 & 3 compatibility
		sys.stdout.write("Add a user account? [Y/n] ")
		choice = sys.stdin.readline().strip()
		
		# Check if the input was something like "n" or "no"
		if choice.lstrip().lower().startswith("n"):
			break
		
		# Prompt for user name
		sys.stdout.write("Name of user account: ")
		name = sys.stdin.readline().strip()
		
		# Actually add the user account within the docker container
		status = subprocess.call(["docker", "exec", "-it", "ghidra-server", "/ghidra/server/svrAdmin", "-add", name])
		if status != 0:
			print("Command exited abnormally")
			break
		
		print("User '%s' added!" % (name,))


if __name__ == "__main__":
	main()
