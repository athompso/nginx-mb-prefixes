# nginx-mb-prefixes

Run the `populate_mb_prefix_list.sh` shell script from cron as often as you like, keeping in mind you're briefly hammering someone's LG every time it runs.

The script will generate a list of IP prefixes that can be include()'d straight into an nginx.conf file.

A sample nginx.conf file has been provided - do not use it as-is.
