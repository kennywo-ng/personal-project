import os, os.path
import sys
import shutil

#append after
cron_first_half = "/bin/php -q /opt/source-code/repo/cron.php app-env=production var1="

#cron command array
cron_command = []

while True:
    variable = input("Var = ")

    #if input = end, end loop
    if variable == "End" or variable == "end":
        break
    else:
        cron_command.append(cron_first_half + variable + " >> /var/log/cron-log/" + variable.upper() +  "cron.log 2>&1")

#push all commands to the file
file = open("/Users/kennywong/Desktop/cron_php.txt", "a")
for cron1 in cron_command:
    file.write(cron1 + "\n")


file.close()