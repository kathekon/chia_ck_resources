
#Guide:  https://spacefarmers.io/wiki/guides/farming/chia_autostart_linux

* file will run harvester only
*copy to /etc/systemd/system  
  
#Step 1 - Create the Chia service
Create the Chia service: sudo nano /etc/systemd/system/chia@.service and paste the following service:

Note: Replace {USERNAME} (2x) with the name of the user having Chia installed.
(Note I also modified the first ExecStart= line to re:
  ExecStart=/usr/bin/bash -c ". ./activate && chia start harvester -r && deactivate"

[Unit]
Description=Chia Service
[Service]
Type=forking
User={USERNAME}
WorkingDirectory=/home/{USERNAME}/chia-blockchain
ExecStart=/usr/bin/bash -c ". ./activate && chia start %i && deactivate"
ExecStop=/usr/bin/bash -c ". ./activate && chia stop -d all && deactivate"
Restart=always
[Install]
WantedBy=multi-user.target


#Step 2 - Reload systemd manager
Reloading the systemd manager is needed to work with our new service.

sudo systemctl daemon-reload


#Step 3 - Enable the Chia service
The service can take an argument after the '@'. Use this argument to start the required chia service.

For example, to enable the farmer:

sudo systemctl enable --now chia@farmer
Running sudo systemctl status chia@farmer will now give the following output:

$ systemctl status chia@farmer.service 
● chia@farmer.service - Chia Service
     Loaded: loaded (/etc/systemd/system/chia@.service; enabled; vendor preset: enabled)
     Active: active (running) since Fri 2021-12-10 21:40:53 CET; 21s ago
    Process: 13500 ExecStart=/usr/bin/bash -c . ./activate && chia start farmer && deactivate (code=exited, status=0/SUCCESS)
   Main PID: 13514 (chia_daemon)
      Tasks: 17 (limit: 9278)
     Memory: 1.4G
     CGroup: /system.slice/system-chia.slice/chia@farmer.service
             ├─13514 chia_daemon
             ├─13520 chia_harvester
             ├─13521 chia_farmer
             ├─13522 chia_full_node
             └─13523 chia_wallet

Dec 10 21:40:47 chia systemd[1]: Starting Chia Service...
Dec 10 21:40:53 chia bash[13501]: Daemon not started yet
Dec 10 21:40:53 chia bash[13501]: Starting daemon
Dec 10 21:40:53 chia bash[13501]: chia_harvester: started
Dec 10 21:40:53 chia bash[13501]: chia_farmer: started
Dec 10 21:40:53 chia bash[13501]: chia_full_node: started
Dec 10 21:40:53 chia bash[13501]: chia_wallet: started
Dec 10 21:40:53 chia systemd[1]: Started Chia Service.
It should say “Active: active” and “enabled” in the Loaded section.

From now on, when you reboot the system, Chia should automatically start up.
