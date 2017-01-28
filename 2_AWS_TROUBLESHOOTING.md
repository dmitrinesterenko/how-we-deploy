## Notes on why it is not working
Find what processes are listening to ports and IPs on your instance
`sudo netstat -tulpn`
iptables is the local Linux firewall on the instance
`service iptables stop` to disable it to check if it's the problem.
[Here](https://fedoraproject.org/wiki/How_to_edit_iptables_rules) is lots more
on working with iptables in Linux.
Adding your port to the iptable allow list like so:

```
sudo iptables -I INPUT 1 -p tcp -m state --state NEW -m tcp --dport 3000 -j ACCEPT
sudo /etc/init.d/iptables save
```
Remove the 1st rule like so:
```
sudo iptables -D INPUT 1
```

You need to bind your application process to the private IP which is NOT 127.0.0.1 (a side conversation
about network interfaces can happen here).
When launching your app:
`hostname -i | xargs rails server -p 3000 -b $1`
